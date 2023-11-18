// Feather disable all

function __VinylClassLabel() constructor
{
    static __idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    __Reset();
    
    static __Reset = function()
    {
        __name                  = undefined;
        __isChild               = false;
        __parent                = __VINYL_ASSET_NULL;
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
    
    static __SerializeShared = function(_struct)
    {
        //TODO - Compress on save
        
        _struct.name                  = __name;
        _struct.isChild               = __isChild;
        _struct.parent                = __parent;
        _struct.childArray            = __childArray;
        
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
    
    static __DeserializeShared = function(_struct)
    {
        //TODO - Decompress on load
        
        __name                  = _struct.name;
        __isChild               = _struct.isChild;
        __parent                = _struct.parent;
        __childArray            = variable_clone(_struct.childArray);
        
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
    
    static __CopyTo = function(_new)
    {
        _new.__Reset();
        
        _new.__name                  = __name;
        _new.__isChild               = __isChild;
        _new.__parent                = __parent;
        _new.__childArray            = variable_clone(__childArray);
        
        _new.__gainOption            = __gainOption;
        _new.__gainKnob              = __gainKnob;
        _new.__gainKnobOverride      = __gainKnobOverride;
        _new.__gain                  = variable_clone(__gain);
        
        _new.__pitchOption           = __pitchOption;
        _new.__pitchKnob             = __pitchKnob;
        _new.__pitchKnobOverride     = __pitchKnobOverride;
        _new.__pitch                 = variable_clone(__pitch);
        
        _new.__loopOption            = __loopOption;
        _new.__loop                  = __loop;
        
        _new.__stackOption           = __stackOption;
        _new.__stackName             = __stackName;
        _new.__stackPriority         = __stackPriority;
        
        _new.__effectChainOption     = __effectChainOption;
        _new.__effectChainName       = __effectChainName;
        
        _new.__persistentOption      = __persistentOption;
        _new.__persistent            = __persistent;
        
        _new.__transposeOption       = __transposeOption;
        _new.__transposeKnob         = __transposeKnob;
        _new.__transposeKnobOverride = __transposeKnobOverride;
        _new.__transpose             = variable_clone(__transpose);
    }
    
    static toString = function()
    {
        return "<label " + __name + ">";
    }
    
    #region Initialize
    
    static __Initialize = function(_labelData = {})
    {
        if (!is_struct(_labelData)) __VinylError("Error in ", self, "\nLabel data must be a struct");
        if (VINYL_CONFIG_VALIDATE_PROPERTIES) __VinylValidateStruct(_labelData, ["gain", "pitch", "transpose", "loop", "tag", "effect chain", "stack", "stack priority", "children"]);
        
        static _stackDict = __VinylGlobalData().__stackDict;
        
        //Unpack the definition data
        var _gain            = _labelData[$ "gain"          ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _labelData[$ "pitch"         ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _transpose       = _labelData[$ "transpose"     ];
        var _loop            = _labelData[$ "loop"          ] ?? undefined;
        var _persistent      = _labelData[$ "persistent"    ];
        var _stack           = _labelData[$ "stack"         ];
        var _stackPriority   = _labelData[$ "stack priority"] ?? 0;
        var _tagArray        = _labelData[$ "tag"           ] ?? _labelData[$ "tags"];
        var _effectChainName = _labelData[$ "effect chain"  ];
        
        //Sort out the gain
        var _knobGain = __VinylParseKnob(_gain, "gain", true, self);
        __configGainKnob = (_knobGain != undefined);
        _gain            = _knobGain ?? _gain;
        
        if (is_numeric(_gain) && (_gain > 0))
        {
            __configGainLo = _gain;
            __configGainHi = _gain;
        }
        else if (is_array(_gain))
        {
            if (array_length(_gain) != 2) __VinylError("Error in ", self, "\n\"gain\" property array must have exactly two elements (length=", array_length(_gain), ")");
            
            __configGainLo = _gain[0];
            __configGainHi = _gain[1];
            
            if (__configGainLo > __configGainHi)
            {
                __VinylTrace("Warning! Error in ", self, " \"gain\" property. Low gain (", __configGainLo, ") is greater than high gain (", __configGainHi, ")");
                var _temp = __configGainLo;
                __configGainLo = __configGainHi;
                __configGainHi = _temp;
            }
        }
        else
        {
            __VinylError("Error in ", self, "\n\"gain\" property must be either a number greater than zero, a two-element array, or a knob");
        }
        
        if (VINYL_CONFIG_DECIBEL_GAIN)
        {
            __configGainLo = __VinylGainToAmplitude(__configGainLo);
            __configGainHi = __VinylGainToAmplitude(__configGainHi);
        }
        
        //Sort out the pitch
        var _knobPitch = __VinylParseKnob(_pitch, "pitch", true, self);
        __configPitchKnob = (_knobPitch != undefined);
        _pitch            = _knobPitch ?? _pitch;
        
        if (is_numeric(_pitch) && (_pitch > 0))
        {
            __configPitchLo = _pitch;
            __configPitchHi = _pitch;
        }
        else if (is_array(_pitch))
        {
            if (array_length(_pitch) != 2) __VinylError("Error in ", self, "\n\"pitch\" property array must have exactly two elements (length=", array_length(_pitch), ")");
            
            __configPitchLo = _pitch[0];
            __configPitchHi = _pitch[1];
            
            if (__configPitchLo > __configPitchHi)
            {
                __VinylTrace("Warning! Error in ", self, " \"pitch\" property. Low pitch (", __configPitchLo, ") is greater than high pitch (", __configPitchHi, ")");
                var _temp = __configPitchLo;
                __configPitchLo = __configPitchHi;
                __configPitchHi = _temp;
            }
        }
        else
        {
            __VinylError("Error in ", self, "\n\"pitch\" property must be either a number greater than zero, a two-element array, or a knob");
        }
        
        if (VINYL_CONFIG_PERCENTAGE_PITCH)
        {
            __configPitchLo /= 100;
            __configPitchHi /= 100;
        }
        
        //Sort out the transposition
        var _knobTranspose = __VinylParseKnob(_transpose, "transpose", false, self);
        __configTranspose = _knobTranspose ?? _transpose;
        if (!is_numeric(__configTranspose) && !is_undefined(__configTranspose)) __VinylError("Error in ", self, "\n\"transpose\" property must be a number or a knob");
        
        //Sort out the stack
        if (is_undefined(_stack))
        {
            __stackName = _stack;
        }
        else if (is_string(_stack))
        {
            if (variable_struct_exists(_stackDict, _stack))
            {
                __stackName = _stack;
            }
            else
            {
                __VinylError("Error in ", self, "\nStack \"", _stack, "\" not found in config file");
            }
        }
        else
        {
            __VinylError("Error in ", self, "\n\"stack\" property must be a string");
        }
        
        if (is_numeric(_stackPriority))
        {
            __stackPriority = _stackPriority;
        }
        else
        {
            __VinylError("Error in ", self, "\n\"stack priority\" property must be a number");
        }
        
        //Sort out the loop state
        __configLoop = _loop;
        if (!is_bool(__configLoop) && !is_undefined(__configLoop)) __VinylError("Error in ", self, "\n\"loop\" property must be a boolean (<true> or <false>)");
        
        //Sort out the persistent state
        __configPersistent = _persistent;
        if (!is_bool(__configPersistent) && !is_undefined(__configPersistent)) __VinylError("Error in ", self, "\n\"persistent\" property must be a boolean (<true> or <false>)");
        
        //Convert the tag array into an array if necessary
        if (is_string(_tagArray)) _tagArray = [_tagArray];
        __tagArray = _tagArray;
        
        //Sort out the effect chain name
        __effectChainName = _effectChainName ?? ((__parent != undefined)? __parent.__effectChainName : undefined);
        
        //Set remainder of the state
        __topLevelArray = [];
        
        __gainLocal  = 1;
        __pitchLocal = 1;
        
        __gainTarget  = __gainLocal;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __pitchTarget = __pitchLocal;
        __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
        
        __gainOutput  = __gainLocal;
        __pitchOutput = __pitchLocal;
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating definition for ", self, ", gain=", __gainOutput*__configGainLo, " -> ", __gainOutput*__configGainHi, ", pitch=", __pitchOutput*__configPitchLo, " -> ", __pitchOutput*__configPitchHi);
    }
    
    static __Store = function(_document)
    {
        var _labelDict  = _document.__labelDict;
        var _labelArray = _document.__labelArray;
        
        _labelDict[$ __name] = self;
        array_push(_labelArray, self);
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
    
    
    
    static __CopyOldState = function(_oldLabel)
    {
        __gainLocal  = _oldLabel.__gainLocal;
        __pitchLocal = _oldLabel.__pitchLocal;
        
        __gainTarget  = _oldLabel.__gainTarget;
        __gainRate    = _oldLabel.__gainRate;
        __pitchTarget = _oldLabel.__pitchTarget;
        __pitchRate   = _oldLabel.__pitchRate;
        
        if (VINYL_DEBUG_READ_CONFIG)
        {
            __VinylTrace("Copying state to ", self, ":");
            __VinylTrace("    gain in=", __gainLocal, "/out=", __gainOutput, ", pitch in=", __pitchLocal, "/out=", __pitchOutput);
            __VinylTrace("    gain target=", __gainTarget, ", rate=", __gainRate, "/s");
            __VinylTrace("    pitch target=", __pitchTarget, ", rate=", __pitchRate, "/s");
        }
    }
    
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
