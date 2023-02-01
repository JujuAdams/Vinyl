/// @param name
/// @param parent
/// @param dynamic
/// @param label

function __VinylClassLabel(_name, _parent, _dynamic, _labelData = {}) constructor
{
    __name    = _name;
    __parent  = _parent;
    __dynamic = _dynamic;
    
    
    
    //Unpack the definition data
    var _gain         = _labelData[$ "gain" ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
    var _pitch        = _labelData[$ "pitch"] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
    var _loop         = _labelData[$ "loop" ] ?? undefined;
    var _limit        = _labelData[$ "limit"] ?? 100;
    var _limitFadeOut = _labelData[$ "limit fade out rate"] ?? VINYL_DEFAULT_GAIN_RATE;
    var _tagArray     = _labelData[$ "tag"] ?? _labelData[$ "tags"];
    
    if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
    if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
    
    if (!is_numeric(_gain)) __VinylError("Error in label \"", __name, "\"\nGain must be a number");
    __configGain = _gain;
    
    if (!is_bool(_loop) && !is_undefined(_loop)) __VinylError("Error in label \"", __name, "\"\nLoop behaviour must be a boolean (<true> or <false>)");
    __configLoop = _loop;
    
    if (is_numeric(_pitch) && (_pitch >= 0))
    {
        __configPitchLo = _pitch;
        __configPitchHi = _pitch;
    }
    else if (is_array(_pitch))
    {
        if (array_length(_pitch) != 2) __VinylError("Error in label \"", __name, "\"\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
        __configPitchLo = _pitch[0];
        __configPitchHi = _pitch[1];
        
        if (__configPitchLo > __configPitchHi)
        {
            __VinylTrace("Warning! Error in audio asset \"", audio_get_name(__sound), "\". Low pitch (", __configPitchLo, ") is greater than high pitch (", __configPitchHi, ")");
            var _temp = __configPitchLo;
            __configPitchLo = __configPitchHi;
            __configPitchHi = _temp;
        }
    }
    else
    {
        __VinylError("Error in label \"", __name, "\"\nPitch must be either a number greater than or equal to zero, or a two-element array");
    }
    
    if (!is_numeric(_limit) || (_limit <= 0)) __VinylError("Error in label \"", __name, "\"\nInstance limit must be a number greater than zero");
    __limitMaxCount = _limit;
    
    if (!is_numeric(_limitFadeOut) || (_limitFadeOut <= 0)) __VinylError("Error in label \"", __name, "\"\nLimit-related fade in rate must be a number greater than zero");
    __limitFadeOutRate = _limitFadeOut;
    
    //Convert the tag array into an array if necessary
    if (is_string(_tagArray)) _tagArray = [_tagArray];
    __tagArray = _tagArray;
    
    
    
    //Set remainder of the state
    __audioArray = [];
    
    __inputGain  = 1;
    __inputPitch = 1;
    
    __gainTarget  = __inputGain;
    __gainRate    = VINYL_DEFAULT_GAIN_RATE;
    __pitchTarget = __inputPitch;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    
    __outputGain  = __inputGain;
    __outputPitch = __inputPitch;
    
    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating label definition for \"",__name, "\", gain=", __outputGain, ", pitch=", __outputPitch*__configPitchLo, " -> ", __outputPitch*__configPitchHi, ", max instances=", __limitMaxCount);
    
    
    
    static __Stop = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylStop(__audioArray[_i]);
            ++_i;
        }
        
        array_resize(__audioArray, 0);
    }
    
    static __Pause = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylPause(__audioArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylResume(__audioArray[_i]);
            ++_i;
        }
    }
    
    static __CopyOldState = function(_oldLabel)
    {
        __inputGain  = _oldLabel.__inputGain;
        __inputPitch = _oldLabel.__inputPitch;
        
        __gainTarget  = _oldLabel.__gainTarget;
        __gainRate    = _oldLabel.__gainRate;
        __pitchTarget = _oldLabel.__pitchTarget;
        __pitchRate   = _oldLabel.__pitchRate;
        
        if (VINYL_DEBUG_READ_CONFIG)
        {
            __VinylTrace("Copying state to label \"", __name, "\":");
            __VinylTrace("    gain in=", __inputGain, "/out=", __outputGain, ", pitch in=", __inputPitch, "/out=", __outputPitch);
            __VinylTrace("    gain target=", __gainTarget, ", rate=", __gainRate, "/s");
            __VinylTrace("    pitch target=", __pitchTarget, ", rate=", __pitchRate, "/s");
        }
    }
    
    static __AddInstance = function(_id)
    {
        if (__limitMaxCount >= 0)
        {
            while (array_length(__audioArray) >= __limitMaxCount)
            {
                var _oldestInstance = global.__vinylIdToInstanceDict[? __audioArray[0]];
                array_delete(__audioArray, 0, 1);
                
                if (is_struct(_oldestInstance))
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Label \"", __name, "\" will exceed ", __limitMaxCount, " playing instance(s), fading out oldest instance ", _oldestInstance.__id, " playing ", audio_get_name(_oldestInstance.__sound));
                    _oldestInstance.__FadeOut(__limitFadeOutRate);
                }
            }
        }
        
        //Add this instance to each label's playing array
        //Playing instances are removed from labels inside the label's __Tick() method
        //  N.B. This has no protection for duplicate entries!
        array_push(__audioArray, _id);
    }
    
    static __BuildAssetLabelArray = function(_labelArray, _labelDict)
    {
        if (!variable_struct_exists(_labelDict, __name))
        {
            _labelDict[$ __name] = self;
            array_push(_labelArray, self);
        }
        
        if (is_struct(__parent)) __parent.__BuildAssetLabelArray(_labelArray, _labelDict);
    }
    
    
    
    #region Gain
    
    static __InputGainSet = function(_gain)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" gain=", _gain);
        }
        
        __inputGain  = _gain;
        __gainTarget = _gain;
    }
    
    static __InputGainTargetSet = function(_targetGain, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" gain target=", _targetGain, ", rate=", _rate, "/s");
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
    }
    
    static __FadeOut = function(_rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Fading out ", array_length(__audioArray), " audio instances playing with label \"", __name, "\"");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            __audioArray[_i].__FadeOut(_rate);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __InputPitchSet = function(_pitch)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch=", _pitch);
        }
        
        __inputPitch  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __InputPitchTargetSet = function(_targetPitch, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch target=", _targetPitch, ", rate=", _rate, "/s");
        }
        
        __pitchTarget = _targetPitch;
        __pitchRate   = _rate;
    }
    
    #endregion
    
    
    
    static __Tick = function(_deltaTime)
    {
        //Update input values based on gain/pitch target
        __inputGain  += clamp(__gainTarget  - __inputGain,  -_deltaTime*__gainRate,  _deltaTime*__gainRate );
        __inputPitch += clamp(__pitchTarget - __inputPitch, -_deltaTime*__pitchRate, _deltaTime*__pitchRate);
        
        //Update the output gain
        var _oldGain  = __outputGain;
        var _oldPitch = __outputPitch;
        
        __outputGain  = __inputGain*__configGain;
        __outputPitch = __inputPitch;
        
        var _gainDelta  = __outputGain  / _oldGain;
        var _pitchDelta = __outputPitch / _oldPitch;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 1) || (_pitchDelta != 1))
        {
            var _i = 0;
            repeat(array_length(__audioArray))
            {
                var _instance = global.__vinylIdToInstanceDict[? __audioArray[_i]];
                if (!is_struct(_instance))
                {
                    array_delete(__audioArray, _i, 1);
                }
                else
                {
                    _instance.__outputChanged = true;
                    
                    if ((_oldGain == 0) || (_oldPitch == 0))
                    {
                        _instance.__ApplyLabel(false);
                        _instance.__outputChanged = true;
                    }
                    else
                    {
                        _instance.__outputGain  *= _gainDelta;
                        _instance.__outputPitch *= _pitchDelta;
                    }
                    
                    ++_i;
                }
            }
        }
    }
}