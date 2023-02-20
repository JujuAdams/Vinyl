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
    
    static __ResetStateCommon = function()
    {
        __patternName = undefined;
        
        __loop       = undefined;
        __pan        = undefined;
        __gainInput  = 1;
        __pitchInput = 1;
        
        __transposeUsing     = false;
        __transposeSemitones = 0;
        __transposePitch     = 1; //Internal value, stored as normalized percentage
        
        __shutdown = false;
        
        __gainTarget  = __gainInput;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __gainOutput  = 1;
        
        __pitchTarget = __pitchInput;
        __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
        __pitchOutput = 1;
        
        __randomPitchParam = 0.5;
        
        __outputChanged = false;
        
        __panEmitter = undefined;
    }
    
    
    
    #region Gain
    
    static __GainSet = function(_gain)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain for ", self, ", it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " gain=", _gain);
        }
        
        __gainInput  = _gain;
        __gainTarget = _gain;
    }
    
    static __GainGet = function()
    {
        return __gainInput;
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
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace(self, " pitch=", _pitch);
        }
        
        __pitchInput  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __PitchGet = function()
    {
        return __pitchInput;
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
            __transposePitch     = __VinylSemitoneToPitch(_semitones + __globalData.__transposeSemitones);
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
            
            __pitchOutput /= __transposePitch;
            
            __transposeUsing     = false;
            __transposeSemitones = 0;
            __transposePitch     = 1;
            
            __outputChanged = true;
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
        __instance.__LoopSet(_state);
    }
    
    static __LoopPointsSet = function()
    {
        __instance.__LoopPointsSet();
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __IsPlaying = function()
    {
        return (__instance != undefined);
    }
    
    static __Pause = function()
    {
        if (__instance == undefined) return;
        __instance.__Pause();
    }
    
    static __Resume = function()
    {
        if (__instance == undefined) return;
        __instance.__Resume();
    }
    
    static __FadeOut = function(_rate)
    {
        __GainTargetSet(0, _rate, true);
    }
    
    static __Stop = function()
    {
        if (__instance == undefined) return;
        
        __instance.__Stop();
        __instance = undefined;
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (__instance == undefined) return 0;
        return __instance.__LengthGet();
    }
    
    static __PositionSet = function(_position)
    {
        if (__instance == undefined) return;
        return __instance.__PositionSet(_position);
    }
    
    static __PositionGet = function()
    {
        if (__instance == undefined) return 0;
        return __instance.__PositionGet();
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
    
    
    
    static __ApplyLabel = function(_initialize)
    {
        //Update the output values based on the asset and labels
        __gainOutput  = __gainInput;
        __pitchOutput = __pitchInput;
        
        var _asset = __VinylPatternGet(__patternName);
        if (is_struct(_asset))
        {
            __gainOutput *= _asset.__gain;
            var _assetPitch = lerp(_asset.__pitchLo, _asset.__pitchHi, __randomPitchParam);
            __pitchOutput *= _assetPitch;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                
                __gainOutput *= _label.__gainOutput;
                var _labelPitch = lerp(_label.__configPitchLo, _label.__configPitchHi, __randomPitchParam);
                __pitchOutput *= _labelPitch*_label.__pitchOutput;
                
                if (_initialize) _label.__AddInstance(__id);
                
                ++_i;
            }
        }
    }
    
    static __GetLoopFromLabel = function()
    {
        var _asset = __VinylPatternGet(__patternName);
        return is_struct(_asset)? _asset.__GetLoopFromLabel() : false;
    }
    
    static __DepoolCallback = function()
    {
        __idToInstanceDict[? __id] = self;
    }
    
    static __PoolCallback = function()
    {
        ds_map_delete(__idToInstanceDict, __id);
        
        __Stop();
        
        //Remove this instance from all labels that we're attached to
        var _asset = __VinylPatternGet(__patternName);
        if (is_struct(_asset))
        {
            var _id = __id;
            var _labelArray = _asset.__labelArray;
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
        
        __ResetState();
        
        //If we're playing on a pan emitter, pool it
        if (__panEmitter != undefined)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " was using ", __panEmitter, ", pooling it");
            
            with(__panEmitter)
            {
                //Pan emitters aren't ticked every frame so make sure we clear up the active array
                __VINYL_RETURN_SELF_TO_POOL_SAFE
            }
            
            __panEmitter = undefined;
        }
    }
}