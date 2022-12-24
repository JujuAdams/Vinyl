/// @param name
/// @param parent
/// @param dynamic
/// @param label

function __VinylClassLabel(_name, _parent, _dynamic, _labelData = {}) constructor
{
    __name    = _name;
    __parent  = _parent;
    __dynamic = _dynamic;
    
    __assetGain  = _labelData[$ "gain" ] ?? 0;
    __assetPitch = _labelData[$ "pitch"] ?? 100;
    __assetLoop  = _labelData[$ "loop" ] ?? undefined;
    
    __limitMaxCount    = _labelData[$ "limit"] ?? infinity;
    __limitFadeOutRate = abs(_labelData[$ "limit fade out rate"] ?? VINYL_DEFAULT_GAIN_RATE);
    
    __audioArray = [];
    
    __inputGain  = 0;
    __inputPitch = 1;
    
    __gainTarget  = 0.0;
    __gainRate    = VINYL_DEFAULT_GAIN_RATE;
    __pitchTarget = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    
    __outputGain  = 0;
    __outputPitch = 1;
    
    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating label definition for \"",__name, "\", gain=", __assetGain, " db, pitch=", __assetPitch, "%, max instances=", __limitMaxCount);
    
    
    
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
            __VinylTrace("    gain in=", __inputGain, " dB/out=", __outputGain, " dB, pitch in=", __inputPitch, "%/out=", __outputPitch, "%");
            __VinylTrace("    gain target=", __gainTarget, " dB, rate=", __gainRate, " dB/s");
            __VinylTrace("    pitch target=", __pitchTarget, "%, rate=", __pitchRate, "%/s");
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
            __VinylTrace("Label \"", __name, "\" gain=", _gain, " db");
        }
        
        __inputGain  = _gain;
        __gainTarget = _gain;
    }
    
    static __InputGainTargetSet = function(_targetGain, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" gain target=", _targetGain, " db, rate=", _rate, " db/s");
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
            VinylFadeOut(__audioArray[_i]);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __InputPitchSet = function(_pitch)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch=", _pitch, "%");
        }
        
        __inputPitch  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __InputPitchTargetSet = function(_targetPitch, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Label \"", __name, "\" pitch target=", _targetPitch, "%, rate=", _rate, "%/s");
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
        var _gainDelta  = __outputGain;
        var _pitchDelta = __outputPitch;
        
        __outputGain  = __inputGain  + __assetGain;
        __outputPitch = __inputPitch * __assetPitch;
        
        _gainDelta  = __outputGain  - _gainDelta;
        _pitchDelta = __outputPitch / _pitchDelta;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 0) || (_pitchDelta != 1))
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
                    
                    _instance.__outputGain  += _gainDelta;
                    _instance.__outputPitch *= _pitchDelta;
                    
                    ++_i;
                }
            }
        }
    }
}