// Feather disable all

function __VinylClassLabel() constructor
{
    static __idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    __gainLocal  = 1;
    __pitchLocal = 1;
    
    __gainTarget  = __gainLocal;
    __gainRate    = VINYL_DEFAULT_GAIN_RATE;
    __pitchTarget = __pitchLocal;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    
    __gainOutput  = __gainLocal;
    __pitchOutput = __pitchLocal;
    
    __topLevelArray = [];
    
    __Reset();
    
    static __Reset = function()
    {
        __name                  = undefined;
        __parent                = undefined;
        __childArray            = [];
        
        __gainOption            = __VINYL_OPTION_UNSET;
        __gain                  = [1, 1];
        __gainKnob              = __VINYL_ASSET_NULL;
        __gainKnobOverride      = false;
        
        __pitchOption           = __VINYL_OPTION_UNSET;
        __pitch                 = [1, 1];
        __pitchKnob             = __VINYL_ASSET_NULL;
        __pitchKnobOverride     = false;
        
        __loopOption            = __VINYL_OPTION_UNSET;
        __loop                  = false;
        
        __stackOption           = __VINYL_OPTION_UNSET;
        __stackName             = __VINYL_ASSET_NULL;
        __stackPriority         = 0;
        
        __effectChainOption     = __VINYL_OPTION_UNSET;
        __effectChainName       = __VINYL_ASSET_NULL;
        
        __persistentOption      = __VINYL_OPTION_UNSET;
        __persistent            = undefined;
        
        __transposeOption       = __VINYL_OPTION_UNSET;
        __transpose             = [0, 0];
        __transposeKnob         = __VINYL_ASSET_NULL;
        __transposeKnobOverride = false;
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        _struct.name                  = __name;
        _struct.childArray            = variable_clone(__childArray);
        
        _struct.gainOption            = __gainOption;
        _struct.gainKnob              = __gainKnob;
        _struct.gainKnobOverride      = __gainKnobOverride;
        _struct.gain                  = variable_clone(__gain);
        
        _struct.pitchOption           = __pitchOption;
        _struct.pitchKnob             = __pitchKnob;
        _struct.pitchKnobOverride     = __pitchKnobOverride;
        _struct.pitch                 = variable_clone(__pitch);
        
        _struct.loopOption            = __loopOption;
        _struct.loop                  = __loop;
        
        _struct.stackOption           = __stackOption;
        _struct.stack                 = __stackName;
        _struct.stackPriority         = __stackPriority;
        
        _struct.effectChainOption     = __effectChainOption;
        _struct.effectChain           = __effectChainName;
        
        _struct.persistentOption      = __persistentOption;
        _struct.persistent            = __persistent;
        
        _struct.transposeOption       = __transposeOption;
        _struct.transposeKnob         = __transposeKnob;
        _struct.transposeKnobOverride = __transposeKnobOverride;
        _struct.transpose             = variable_clone(__transpose);
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __ChangeParent(_parent);
        
        __name                  = _struct.name;
        __childArray            = __VinylDeserializeArray(_struct.childArray, self);
        
        __gainOption            = _struct.gainOption;
        __gainKnob              = _struct.gainKnob;
        __gainKnobOverride      = _struct.gainKnobOverride;
        __gain                  = variable_clone(_struct.gain);
        
        __pitchOption           = _struct.pitchOption;
        __pitchKnob             = _struct.pitchKnob;
        __pitchKnobOverride     = _struct.pitchKnobOverride;
        __pitch                 = variable_clone(_struct.pitch);
        
        __loopOption            = _struct.loopOption;
        __loop                  = _struct.loop;
        
        __stackOption           = _struct.stackOption;
        __stackName             = _struct.stack;
        __stackPriority         = _struct.stackPriority;
        
        __effectChainOption     = _struct.effectChainOption;
        __effectChainName       = _struct.effectChain;
        
        __persistentOption      = _struct.persistentOption;
        __persistent            = _struct.persistent;
        
        __transposeOption       = _struct.transposeOption;
        __transposeKnob         = _struct.transposeKnob;
        __transposeKnobOverride = _struct.transposeKnobOverride;
        __transpose             = variable_clone(_struct.transpose);
    }
    
    static toString = function()
    {
        return "<label " + __name + ">";
    }
    
    static __Store = function(_document)
    {
        _document.__labelAllDict[$ __name] = self;
        
        if (not is_struct(__parent))
        {
            _document.__labelRootDict[$ __name] = self;
        }
    }
    
    static __Discard = function(_document)
    {
        variable_struct_remove(_document.__labelAllDict,  __name);
        variable_struct_remove(_document.__labelRootDict, __name);
        
        var _i = 0;
        repeat(array_length(__childArray))
        {
            __childArray[_i].__ChangeParent(__parent);
            ++_i;
        }
    }
    
    static __ChangeParent = function(_parent)
    {
        if (is_struct(__parent))
        {
            var _index = __VinylArrayFindIndex(__parent.__childArray, self);
            if (_index != undefined)
            {
                array_delete(__parent.__childArray, _index, 1);
            }
        }
        
        __parent = _parent;
        
        if (is_struct(_parent))
        {
            array_push(_parent.__childArray, self);
        }
    }
    
    
    
    
    
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
        
        __gainLocal  = _gain;
        __gainTarget = _gain;
    }
    
    static __GainGet = function()
    {
        return __gainLocal;
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
    
    static __GainTargetGet = function()
    {
        return __gainTarget;
    }
    
    static __GainOutputGet = function()
    {
        return __gainOutput;
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
        
        __pitchLocal  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __PitchGet = function()
    {
        return __pitchLocal;
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
    
    static __PitchTargetGet = function()
    {
        return __pitchTarget;
    }
    
    static __PitchOutputGet = function()
    {
        return __pitchOutput;
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __Stop = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", array_length(__topLevelArray), " voices playing (", self, ")");
        
        //Go backwards because each Stop() command removes the voice from the array
        var _i = array_length(__topLevelArray)-1;
        repeat(array_length(__topLevelArray))
        {
            VinylStop(__topLevelArray[_i]);
            --_i;
        }
        
        array_resize(__topLevelArray, 0);
    }
    
    static __Pause = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", array_length(__topLevelArray), " voices playing (", self, ")");
        
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            VinylPause(__topLevelArray[_i]);
            ++_i;
        }
    }
    
    static __Resume = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", array_length(__topLevelArray), " voices playing (", self, ")");
        
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            VinylResume(__topLevelArray[_i]);
            ++_i;
        }
    }
    
    static __FadeOut = function(_rate)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Fading out ", array_length(__topLevelArray), " voices (", self, ")");
        
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            VinylFadeOut(__topLevelArray[_i], _rate);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Stop Callback
    
    static __StopCallbackSet = function(_callback, _data)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            VinylStopCallbackSet(__topLevelArray[_i], _callback, _data);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Queue
    
    static __QueuePush = function(_asset, _dontRepeatLast)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            if (VinylTypeGet(__topLevelArray[_i]) == "queue") VinylQueuePush(__topLevelArray[_i], _asset, _dontRepeatLast);
            ++_i;
        }
    }
    
    static __QueueBehaviorSet = function(_behavior)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            if (VinylTypeGet(__topLevelArray[_i]) == "queue") VinylQueueBehaviorSet(__topLevelArray[_i], _behavior);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    #region Multi
    
    static __MultiGainSet = function(_index, _gain)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            if (VinylTypeGet(__topLevelArray[_i]) == "multi") VinylMultiGainSet(__topLevelArray[_i], _index, _gain);
            ++_i;
        }
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            if (VinylTypeGet(__topLevelArray[_i]) == "multi") VinylMultiBlendSet(__topLevelArray[_i], _blendFactor);
            ++_i;
        }
    }
    
    static __MultiSyncSet = function(_state)
    {
        var _i = 0;
        repeat(array_length(__topLevelArray))
        {
            if (VinylTypeGet(__topLevelArray[_i]) == "multi") VinylMultiSyncSet(__topLevelArray[_i], _state);
            ++_i;
        }
    }
    
    #endregion
    
    
    
    static __VoiceAdd = function(_id)
    {
        //Add this voice to each label's playing array
        //Playing voices are removed from labels inside the label's __Tick() method
        //  N.B. This has no protection for duplicate entries!
        array_push(__topLevelArray, _id);
    }
              
    static __VoiceRemove = function(_id)
    {
        static _closure = {
            __value: undefined,
        };
        
        static _function = method(_closure, function(_value)
        {
            return (__value != _value);
        });
        
        _closure.__value = _id;
        array_resize(__topLevelArray, array_filter_ext(__topLevelArray, _function));
    }
    
    static __LabelArrayAppend = function(_labelArray)
    {
        if (!array_contains(_labelArray, self)) array_push(_labelArray, self);
        if (__parent != undefined) __parent.__LabelArrayAppend(_labelArray);
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        //Update input values based on gain/pitch target
        __gainLocal  += clamp(__gainTarget  - __gainLocal,  -_deltaTimeFactor*__gainRate,  _deltaTimeFactor*__gainRate );
        __pitchLocal += clamp(__pitchTarget - __pitchLocal, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
        
        __gainOutput  = __gainLocal;
        __pitchOutput = __pitchLocal;
    }
}
