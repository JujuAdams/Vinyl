/// @param name
/// @param parent
/// @param dynamic

function __VinylClassLabel(_name, _parent, _dynamic) constructor
{
    static __idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    
    __name    = _name;
    __parent  = _parent;
    __dynamic = _dynamic;
    
    
    
    static toString = function()
    {
        return "<label " + __name + ">";
    }
    
    #region Initialize
    
    static __Initialize = function(_labelData = {}, _knobDict)
    {
        //Unpack the definition data
        var _gain            = _labelData[$ "gain"               ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _labelData[$ "pitch"              ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _loop            = _labelData[$ "loop"               ] ?? undefined;
        var _limit           = _labelData[$ "limit"              ] ?? 100;
        var _limitFadeOut    = _labelData[$ "limit fade out rate"] ?? VINYL_DEFAULT_GAIN_RATE;
        var _tagArray        = _labelData[$ "tag"                ] ?? _labelData[$ "tags"];
        var _effectChainName = _labelData[$ "effect chain"       ];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        
        
        //Sort out the gain
        __configGainKnob = false;
    
        if (is_string(_gain))
        {
            if (string_char_at(_gain, 1) == "@")
            {
                var _knobName = string_delete(_gain, 1, 1);
                var _knob = _knobDict[$ _knobName];
                if (!is_struct(_knob)) __VinylError("Error in ", self, " for gain property\nKnob \"", _knobName, "\" doesn't exist");
            
                _knob.__TargetCreate(self, "gain");
                _gain = _knob.__actualValue; //Set gain to the current value of the knob
            
                __configGainKnob = true;
            }
            else
            {
                __VinylError("Error in ", self, "\nGain must be a number or a knob name");
            }
        }
        else if (!is_numeric(_gain))
        {
            __VinylError("Error in ", self, "\nGain must be a number or a knob name");
        }
    
        __configGain = _gain;
    
    
    
        //Sort out the pitch
        __configPitchKnob = false;
    
        if (is_string(_pitch))
        {
            if (string_char_at(_pitch, 1) == "@")
            {
                var _knobName = string_delete(_pitch, 1, 1);
                var _knob = _knobDict[$ _knobName];
                if (!is_struct(_knob)) __VinylError("Error in ", self, " for pitch property\nKnob \"", _knobName, "\" doesn't exist");
            
                _knob.__TargetCreate(self, "pitch");
                __configPitchLo = _knob.__actualValue; //Set pitch to the current value of the knob
                __configPitchHi = __configPitchLo;
            
                __configPitchKnob = true;
            }
            else
            {
                __VinylError("Error in label ", self, "\nPitch must be either a number greater than zero, a two-element array, or a knob name");
            }
        }
        else if (is_numeric(_pitch) && (_pitch > 0))
        {
            __configPitchLo = _pitch;
            __configPitchHi = _pitch;
        }
        else if (is_array(_pitch))
        {
            if (array_length(_pitch) != 2) __VinylError("Error in ", self, "\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
            __configPitchLo = _pitch[0];
            __configPitchHi = _pitch[1];
        
            if (__configPitchLo > __configPitchHi)
            {
                __VinylTrace("Warning! Error in ", self, ". Low pitch (", __configPitchLo, ") is greater than high pitch (", __configPitchHi, ")");
                var _temp = __configPitchLo;
                __configPitchLo = __configPitchHi;
                __configPitchHi = _temp;
            }
        }
        else
        {
            __VinylError("Error in ", self, "\nPitch must be either a number greater than zero, a two-element array, or a knob name");
        }
    
    
    
        //Sort out the loop state
        if (!is_bool(_loop) && !is_undefined(_loop)) __VinylError("Error in ", self, "\nLoop behaviour must be a boolean (<true> or <false>)");
        __configLoop = _loop;
    
    
    
        if (!is_numeric(_limit) || (_limit <= 0)) __VinylError("Error in ", self, "\nInstance limit must be a number greater than zero");
        __limitMaxCount = _limit;
    
        if (!is_numeric(_limitFadeOut) || (_limitFadeOut <= 0)) __VinylError("Error in ", self, "\nLimit-related fade in rate must be a number greater than zero");
        __limitFadeOutRate = _limitFadeOut;
    
        //Convert the tag array into an array if necessary
        if (is_string(_tagArray)) _tagArray = [_tagArray];
        __tagArray = _tagArray;
    
        __effectChainName = _effectChainName ?? ((__parent == undefined)? "main" : __parent.__effectChainName);
    
    
    
        //Set remainder of the state
        __audioArray = [];
    
        __gainInput  = 1;
        __pitchInput = 1;
    
        __gainTarget  = __gainInput;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __pitchTarget = __pitchInput;
        __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    
        __gainOutput  = __gainInput;
        __pitchOutput = __pitchInput;
    
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating definition for ", self, ", gain=", __gainOutput, ", pitch=", __pitchOutput*__configPitchLo, " -> ", __pitchOutput*__configPitchHi, ", max instances=", __limitMaxCount);
    }
    
    #endregion
    
    
    
    #region Gain
    
    static __GainSet = function(_gain, _force = false)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " gain=", _gain);
        }
        
        if (!_force && __configGainKnob)
        {
            __VinylTrace(self, " gain is attached to a knob, cannot change gain manually");
            return;
        }
        
        __gainInput  = _gain;
        __gainTarget = _gain;
    }
    
    static __GainTargetSet = function(_targetGain, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Warning! ", self, " gain target=", _targetGain, ", rate=", _rate, "/s");
        }
        
        if (__configGainKnob)
        {
            __VinylTrace("Warning! ", self, " gain is attached to a knob, cannot set a target gain");
            return;
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __PitchSet = function(_pitch, _force = false)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch=", _pitch);
        }
        
        if (!_force && __configPitchKnob)
        {
            __VinylTrace("Warning! ", self, " pitch is attached to a knob, cannot change pitch manually");
            return;
        }
        
        __pitchInput  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __PitchTargetSet = function(_targetPitch, _rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch target=", _targetPitch, ", rate=", _rate, "/s");
        }
        
        if (__configPitchKnob)
        {
            __VinylTrace("Warning! ", self, " pitch is attached to a knob, cannot set a target pitch");
            return;
        }
        
        __pitchTarget = _targetPitch;
        __pitchRate   = _rate;
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __Stop = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", array_length(__audioArray), " audio instances playing (", self, ")");
        
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
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", array_length(__audioArray), " audio instances playing (", self, ")");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylPause(__audioArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", array_length(__audioArray), " audio instances playing (", self, ")");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylResume(__audioArray[_i]);
            ++_i;
        }
    }
    
    static __FadeOut = function(_rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Fading out ", array_length(__audioArray), " audio instances (", self, ")");
        
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            VinylFadeOut(__audioArray[_i], _rate);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Queue
    
    static __QueuePush = function(_asset, _dontRepeatLast)
    {
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            if (VinylTypeGet(__audioArray[_i]) == "queue") VinylQueuePush(__audioArray[_i], _asset, _dontRepeatLast);
            ++_i;
        }
    }
    
    static __QueueBehaviorSet = function(_behavior)
    {
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            if (VinylTypeGet(__audioArray[_i]) == "queue") VinylQueueBehaviorSet(__audioArray[_i], _behavior);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Multi
    
    static __MultiGainSet = function(_index, _gain)
    {
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            if (VinylTypeGet(__audioArray[_i]) == "multi") VinylMultiGainSet(__audioArray[_i], _index, _gain);
            ++_i;
        }
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            if (VinylTypeGet(__audioArray[_i]) == "multi") VinylMultiBlendSet(__audioArray[_i], _blendFactor);
            ++_i;
        }
    }
    
    static __MultiSyncSet = function(_state)
    {
        var _i = 0;
        repeat(array_length(__audioArray))
        {
            if (VinylTypeGet(__audioArray[_i]) == "multi") VinylMultiSyncSet(__audioArray[_i], _state);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    static __CopyOldState = function(_oldLabel)
    {
        __gainInput  = _oldLabel.__gainInput;
        __pitchInput = _oldLabel.__pitchInput;
        
        __gainTarget  = _oldLabel.__gainTarget;
        __gainRate    = _oldLabel.__gainRate;
        __pitchTarget = _oldLabel.__pitchTarget;
        __pitchRate   = _oldLabel.__pitchRate;
        
        if (VINYL_DEBUG_READ_CONFIG)
        {
            __VinylTrace("Copying state to ", self, ":");
            __VinylTrace("    gain in=", __gainInput, "/out=", __gainOutput, ", pitch in=", __pitchInput, "/out=", __pitchOutput);
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
                var _oldestInstance = __idToInstanceDict[? __audioArray[0]];
                array_delete(__audioArray, 0, 1);
                
                if (is_struct(_oldestInstance))
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " will exceed ", __limitMaxCount, " playing instance(s), fading out oldest ", _oldestInstance);
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
    
    static __Tick = function(_deltaTimeFactor)
    {
        //Update input values based on gain/pitch target
        __gainInput  += clamp(__gainTarget  - __gainInput,  -_deltaTimeFactor*__gainRate,  _deltaTimeFactor*__gainRate );
        __pitchInput += clamp(__pitchTarget - __pitchInput, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
        
        //Update the output gain
        var _oldGain  = __gainOutput;
        var _oldPitch = __pitchOutput;
        
        __gainOutput  = __gainInput*__configGain;
        __pitchOutput = __pitchInput;
        
        var _gainDelta  = __gainOutput  / _oldGain;
        var _pitchDelta = __pitchOutput / _oldPitch;
        
        //If our values have changed at all, iterate over instances that are labelled to use us
        if ((_gainDelta != 1) || (_pitchDelta != 1))
        {
            var _i = 0;
            repeat(array_length(__audioArray))
            {
                var _instance = __idToInstanceDict[? __audioArray[_i]];
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
                        _instance.__gainOutput  *= _gainDelta;
                        _instance.__pitchOutput *= _pitchDelta;
                    }
                    
                    ++_i;
                }
            }
        }
    }
}