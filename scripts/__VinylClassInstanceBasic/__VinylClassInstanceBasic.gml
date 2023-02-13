function __VinylClassInstanceBasic() constructor
{
    static __globalData       = __VinylGlobalData();
    static __poolPanEmitter   = __globalData.__poolPanEmitter;
    static __idToInstanceDict = __globalData.__idToInstanceDict;
    static __effectChainDict  = __globalData.__effectChainDict;
    
    __id   = undefined;
    __pool = undefined;
    
    __ResetState();
    
    
    
    static toString = function()
    {
        if (__sound == undefined)
        {
            return "<basic inst " + string(__id) + ">";
        }
        else
        {
            return "<basic inst " + string(__id) + " " + string(audio_get_name(__sound)) + ">";
        }
    }
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __patternName = undefined;
        
        __sound      = undefined;
        __loop       = undefined;
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
        
        __gmInstance = undefined;
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
    
    #endregion
    
    
    
    #region Loop
    
    static __LoopSet = function(_state)
    {
        __loop = _state;
        __gmInstance.__LoopSet(_state);
    }
    
    static __LoopPointsSet = function()
    {
        __gmInstance.__LoopPointsSet();
    }
    
    #endregion
    
    
    
    #region Play
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        //Set the state
        __patternName = _sound;
        __sound       = _sound;
        __loop        = _loop ?? __GetLoopFromLabel();
        __gainInput   = _gain;
        __pitchInput  = _pitch;
        
        __gainTarget  = __gainInput;
        __pitchTarget = __pitchInput;
        
        __randomPitchParam = __VinylRandom(1);
        
        __ApplyLabel(true);
        
        var _effectChainName = __VinylPatternGetEffectChain(__sound);
        
        var _usedEmitter = undefined;
        if (_emitter != undefined)
        {
            //Playback on a normal emitter
            _usedEmitter = _emitter.__GetEmitter();
            
            //Add this instance to the emitter's array
            array_push(_emitter.__emitter.__instanceIDArray, __id);
        }
        else
        {
            if (_pan == undefined)
            {
                //Standard playback
                //Only use an emitter if the effect chain demands it
                var _usedEmitter = __VinylEffectChainGetEmitter(_effectChainName);
            }
            else
            {
                //Playback on a pan emitter
                __panEmitter = __poolPanEmitter.__Depool();
                __panEmitter.__Pan(_pan);
                __panEmitter.__Bus(_effectChainName);
                
                _usedEmitter = __panEmitter.__emitter;
            }
        }
        
        __gmInstance = new __VinylClassInstanceGameMaker(); //TODO - Pool GameMaker instance wrappers
        __gmInstance.__Play(_usedEmitter, __sound, __loop, __gainOutput, __pitchOutput);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " hosting ", __gmInstance);
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __Pause = function()
    {
        if (__gmInstance == undefined) return;
        __gmInstance.__Pause();
    }
    
    static __Resume = function()
    {
        if (__gmInstance == undefined) return;
        __gmInstance.__Resume();
    }
    
    static __FadeOut = function(_rate)
    {
        __GainTargetSet(0, _rate, true);
    }
    
    static __Stop = function()
    {
        if (__gmInstance == undefined) return;
        
        __gmInstance.__Stop();
        __gmInstance = undefined;
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    #endregion
    
    
    
    static __ApplyLabel = function(_initialize)
    {
        //Update the output values based on the asset and labels
        __gainOutput  = __gainInput;
        __pitchOutput = __pitchInput;
        
        var _asset = __VinylPatternGet(__sound);
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
        var _asset = __VinylPatternGet(__sound);
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
        var _asset = __VinylPatternGet(__sound);
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
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__gmInstance == undefined) || !__gmInstance.__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            var _delta = clamp(__gainTarget - __gainInput, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
            if (_delta != 0)
            {
                __gainInput  += _delta;
                __gainOutput += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta < 0) && ((__gainInput <= 0) || (__gainOutput <= 0)))
                {
                    __Stop();
                    return;
                }
            }
            
            var _delta = clamp(__pitchTarget - __pitchInput, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
            if (_delta != 0)
            {
                __pitchInput  += _delta;
                __pitchOutput += _delta;
                __outputChanged = true;
            }
            
            if (__outputChanged)
            {
                __outputChanged = false;
                __gmInstance.__GainSet(__gainOutput);
                __gmInstance.__PitchSet(__pitchOutput);
            }
        }
    }
}