function __VinylClassInstanceCommon() constructor
{
    static __patternType = "???";
    
    static __globalData       = __VinylGlobalData();
    static __idToInstanceDict = __globalData.__idToInstanceDict;
    
    __id   = undefined;
    __pool = undefined;
    
    
    
    static toString = function()
    {
        return "<inst " + string(__id) + ">";
    }
    
    static __StateResetCommon = function()
    {
        __pattern        = undefined;
        __parentInstance = undefined;
        __child          = undefined;
        
        __loop = undefined;
        __pan  = undefined;
        
        __shutdown = false;
        
        __gainLocal   = 1;
        __gainTarget  = 1;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __gainPattern = 1;
        __gainParent  = 1;
        __gainLabels  = 1;
        __gainOutput  = 1;
        
        __pitchLocal       = 1;
        __pitchTarget      = 1;
        __pitchRate        = VINYL_DEFAULT_PITCH_RATE;
        __pitchRandomParam = 0.5;
        __pitchPattern     = 1;
        __pitchParent      = 1;
        __pitchLabels      = 1;
        __pitchOutput      = 1;
        
        __transposeUsing     = false;
        __transposeSemitones = 0;
        
        __gmEmitter  = undefined;
        __panEmitter = undefined;
    }
    
    static __StateSetCommon = function(_pattern, _parentInstance, _emitter, _loop, _gain, _pitch, _pan)
    {
        static _globalTopLevelArray = __globalData.__topLevelArray;
        static _poolPanEmitter = __globalData.__poolPanEmitter;
        
        __pattern        = _pattern;
        __parentInstance = _parentInstance;
        __gainLocal      = _gain;
        __pitchLocal     = _pitch;
        __pan            = _pan;
        
        var _topLevelPattern = __ParentTopLevelGet().__pattern;
        __loop = _loop ?? ((_topLevelPattern == undefined)? false : _topLevelPattern.__LoopGet());
        
        __gainTarget  = __gainLocal;
        __pitchTarget = __pitchLocal;
        
        __pitchRandomParam = __VinylRandom(1);
        
        __LabelAdd();
        __CalculateGainPitch(0);
        
        //Determine which emitter to use given the input arguments
        var _effectChainName = (__pattern == undefined)? "main" : _pattern.__effectChainName;
        if (_emitter != undefined)
        {
            //Playback on a normal emitter
            __gmEmitter = _emitter.__GetEmitter();
            
            //Add this instance to the emitter's array
            array_push(_emitter.__emitter.__instanceIDArray, __id);
        }
        else
        {
            if (__pan == undefined)
            {
                //Standard playback
                //Only use an emitter if the effect chain demands it
                __gmEmitter = __VinylEffectChainGetEmitter(_effectChainName);
            }
            else
            {
                //Playback on a pan emitter
                __panEmitter = _poolPanEmitter.__Depool();
                __panEmitter.__Pan(__pan);
                __panEmitter.__Bus(_effectChainName);
                
                __gmEmitter = __panEmitter.__emitter;
            }
        }
        
        if (__parentInstance == undefined) array_push(_globalTopLevelArray, self);
    }
    
    
    
    #region Gain
    
    static __GainSet = function(_gain)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain for ", self, ", it is set to shut down");
            return;
        }
        
        if ((__gainLocal != _gain) && (VINYL_DEBUG_LEVEL >= 1))
        {
            __VinylTrace(self, " gain=", _gain);
        }
        
        __gainTarget = _gain;
        __gainRate   = infinity;
        
        if (__child != undefined)
        {
            //We're setting the gain instantly so propagate the new gain value
            __child.__GainTargetSet(_gain, infinity, __shutdown);
        }
    }
    
    static __GainGet = function()
    {
        return __gainLocal;
    }
    
    static __GainTargetSet = function(_targetGain, _rate, _stopAtSilence = false)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain target for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " gain target=", _targetGain, ", rate=", _rate, "/s, stop at silence=", _stopAtSilence? "true" : "false");
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
        __shutdown   = _stopAtSilence;
        
        if (__child != undefined)
        {
            //If we're setting the gain instantly then propagate the new gain value
            if (is_infinity(_rate)) __child.__GainTargetSet(_targetGain, _rate, _stopAtSilence);
        }
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
    
    static __PitchSet = function(_pitch)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch for ", self, ", it is set to shut down");
            return;
        }
        
        if ((__pitchLocal != _pitch) && (VINYL_DEBUG_LEVEL >= 1))
        {
            __VinylTrace(self, " pitch=", _pitch);
        }
        
        __pitchTarget = _pitch;
        __pitchRate   = infinity;
        
        if (__child != undefined)
        {
            //We're setting the pitch instantly so propagate the new pitch value
            __child.__PitchTargetSet(_pitch, infinity);
        }
    }
    
    static __PitchGet = function()
    {
        return __pitchLocal;
    }
    
    static __PitchTargetSet = function(_targetPitch, _rate)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch target for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch target=", _targetPitch, ", rate=", _rate, "/s");
        }
        
        __pitchTarget = _targetPitch;
        __pitchRate   = _rate;
        
        if (__child != undefined)
        {
            //If we're setting the pitch instantly then propagate the new pitch value
            if (is_infinity(_rate)) __child.__PitchTargetSet(_targetPitch, _rate);
        }
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
    
    
    
    #region Semitones
    
    static __TransposeSet = function(_semitones)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set transposition for ", self, ", it is set to shut down");
            return;
        }
        
        if (__transposeSemitones != _semitones)
        {
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace(self, " transposition=", _semitones);
            }
            
            __transposeUsing     = true;
            __transposeSemitones = _semitones;
        }
    }
    
    static __TransposeReset = function()
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot reset transposition for ", self, ", it is set to shut down");
            return;
        }
        
        if (__transposeUsing)
        {
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace(self, " transposition reset");
            }
            
            __transposeUsing     = false;
            __transposeSemitones = 0;
        }
    }
    
    static __TransposeGet = function()
    {
        return __transposeSemitones;
    }
    
    #endregion
    
    
    
    #region Loop
    
    static __LoopSet = function(_state)
    {
        __loop = _state;
        if (__child != undefined) __child.__LoopSet(_state);
    }
    
    static __LoopGet = function()
    {
        return __loop;
    }
    
    static __LoopPointsSet = function()
    {
        if (__child != undefined) __child.__LoopPointsSet();
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __IsPlaying = function()
    {
        return (__child != undefined);
    }
    
    static __Pause = function()
    {
        if (__child == undefined) return;
        __child.__Pause();
    }
    
    static __PauseGet = function()
    {
        if (__child == undefined) return;
        return __child.__PauseGet();
    }
    
    static __Resume = function()
    {
        if (__child == undefined) return;
        __child.__Resume();
    }
    
    static __FadeOut = function(_rate)
    {
        __GainTargetSet(0, _rate, true);
    }
    
    static __Stop = function()
    {
        if (__child == undefined) return;
        
        __child.__Stop();
        __child = undefined;
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (__child == undefined) return 0;
        return __child.__LengthGet();
    }
    
    static __PositionSet = function(_position)
    {
        if (__child == undefined) return;
        return __child.__PositionSet(_position);
    }
    
    static __PositionGet = function()
    {
        if (__child == undefined) return 0;
        return __child.__PositionGet();
    }
    
    #endregion
    
    
    
    #region Queue
    
    static __QueuePush = function(_asset, _dontRepeatLast)
    {
        __VinylError("Cannot use VinylQueuePush() on an instance of a ", __patternType, " pattern");
    }
    
    static __QueueBehaviorSet = function(_behavior)
    {
        __VinylError("Cannot use VinylQueueBehaviorSet() on an instance of a ", __patternType, " pattern");
    }
    
    static __QueueBehaviorGet = function()
    {
        __VinylError("Cannot use VinylQueueBehaviorGet() on an instance of a ", __patternType, " pattern");
    }
    
    #endregion
    
    
    
    #region Multi
    
    static __MultiChannelCountGet = function(_asset)
    {
        __VinylError("Cannot use VinylMultiChannelCountGet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiGainSet = function(_index, _gain)
    {
        __VinylError("Cannot use VinylMultiGainSet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiGainGet = function(_index)
    {
        __VinylError("Cannot use VinylMultiGainGet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        __VinylError("Cannot use VinylMultiBlendSet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiBlendGet = function()
    {
        __VinylError("Cannot use VinylMultiBlendGet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiSyncSet = function(_state)
    {
        __VinylError("Cannot use VinylMultiSyncSet() on an instance of a ", __patternType, " pattern");
    }
    
    static __MultiSyncGet = function()
    {
        __VinylError("Cannot use VinylMultiSyncGet() on an instance of a ", __patternType, " pattern");
    }
    
    #endregion
    
    
    
    static __MigrateCommon = function()
    {
        __LabelRemove();
        __pattern = __VinylPatternGet(__pattern.__name);
        __LabelAdd();
        __CalculateGainPitch(0);
        __LoopPointsSet();
    }
    
    static __LabelAdd = function()
    {
        if (__pattern != undefined)
        {
            var _labelArray = __pattern.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                _labelArray[_i].__AddInstance(__id);
                ++_i;
            }
        }
    }
    
    static __LabelRemove = function()
    {
        //Use the top-level parent for label contribution
        var _topPattern = __ParentTopLevelGet().__pattern;
        if (_topPattern != undefined)
        {
            var _id = __id;
            var _labelArray = _topPattern.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _audioArray = _labelArray[_i].__audioArray;
                var _j = 0;
                repeat(array_length(_audioArray))
                {
                    if (_audioArray[_j] == _id)
                    {
                        array_delete(_audioArray, _j, 1);
                        break;
                    }
                    
                    ++_j;
                }
                
                ++_i;
            }
        }
    }
    
    static __LabelGainPitchGet = function()
    {
        //Update the output values based on the asset and labels
        __gainLabels  = 1;
        __pitchLabels = 1;
        
        //Use the top-level parent for label contribution
        var _pattern = __ParentTopLevelGet().__pattern;
        if (_pattern != undefined)
        {
            var _labelArray = _pattern.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                __gainLabels  *= _label.__gainOutput;
                __pitchLabels *= _label.__pitchOutput*lerp(_label.__configPitchLo, _label.__configPitchHi, __pitchRandomParam);
                ++_i;
            }
        }
    }
    
    static __ParentTopLevelGet = function()
    {
        return (__parentInstance == undefined)? self : __parentInstance.__ParentTopLevelGet();
    }
    
    static __DepoolCallback = function()
    {
        __idToInstanceDict[? __id] = self;
    }
    
    static __PoolCallback = function()
    {
        ds_map_delete(__idToInstanceDict, __id);
        
        //If we're playing on a pan emitter, pool it
        if (__panEmitter != undefined)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " was using ", __panEmitter, ", pooling it");
            
            with(__panEmitter)
            {
                __VINYL_RETURN_SELF_TO_POOL
            }
            
            __panEmitter = undefined;
        }
        
        __LabelRemove();
        __Stop();
        __StateReset();
    }
    
    static __CalculateGainPitch = function(_deltaTimeFactor)
    {
        var _gainDelta = clamp(__gainTarget - __gainLocal, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
        
        __LabelGainPitchGet();
        
        __gainLocal += _gainDelta;
        __gainPattern = (__pattern == undefined)? 1 : __pattern.__gain;
        __gainParent = (__parentInstance == undefined)? 1 :__parentInstance.__gainOutput;
        __gainOutput = __gainLocal*__gainPattern*__gainParent*__gainLabels;
        
        __pitchLocal += clamp(__pitchTarget - __pitchLocal, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
        __pitchPattern = (__pattern == undefined)? 1 : lerp(__pattern.__pitchLo, __pattern.__pitchHi, __pitchRandomParam);
        __pitchParent = (__parentInstance == undefined)? 1 : __parentInstance.__pitchOutput;
        __pitchOutput = __pitchLocal*__pitchPattern*__pitchParent*__pitchLabels;
        if (__transposeUsing) __pitchOutput *= __VinylSemitoneToPitch(__globalData.__transposeSemitones + __transposeSemitones);
        
        if (__panEmitter != undefined) __panEmitter.__UpdatePosition();
    }
    
    static __TickCommon = function(_deltaTimeFactor)
    {
        var _canShutdown = (__gainTarget <= __gainLocal);
        
        __CalculateGainPitch(_deltaTimeFactor);
        
        if (_canShutdown && __shutdown && ((__gainLocal <= 0) || (__gainOutput <= 0)))
        {
            __Stop();
            return false;
        }
        
        return true;
    }
}