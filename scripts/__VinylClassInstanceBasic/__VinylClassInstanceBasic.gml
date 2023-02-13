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
            return "<instance " + string(__id) + ">";
        }
        else
        {
            return "<instance " + string(__id) + " " + string(audio_get_name(__sound)) + ">";
        }
    }
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
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
        
        __instance   = undefined;
        __panEmitter = undefined;
        
        __effectChainName = "main";
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
        audio_sound_loop(__instance, _state);
        __loop = _state;
    }
    
    static __LoopPointsSet = function()
    {
        var _loopPoints = __VinylPatternGet(__sound).__loopPoints;
        if (is_array(_loopPoints))
        {
            audio_sound_loop_start(__instance, _loopPoints[0]);
            audio_sound_loop_end(  __instance, _loopPoints[1]);
        }
        else
        {
            audio_sound_loop_start(__instance, 0);
            audio_sound_loop_end(  __instance, audio_sound_length(__instance));
        }
    }
    
    #endregion
    
    
    
    #region Play
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        //Set the state
        __sound      = _sound;
        __loop       = _loop ?? __GetLoopFromLabel();
        __gainInput  = _gain;
        __pitchInput = _pitch;
        
        __gainTarget  = __gainInput;
        __pitchTarget = __pitchInput;
        
        __randomPitchParam = __VinylRandom(1);
        
        __ApplyLabel(true);
        
        var _pattern      = __VinylPatternGet(__sound);
        __effectChainName = is_struct(_pattern)? _pattern.__effectChainName : "main";
        
        
        
        if (_emitter == undefined)
        {
            if (_pan == undefined)
            {
                //Standard playback
                var _effectChainEmitter = __VinylEffectChainGetEmitter(__effectChainName);
                if (_effectChainEmitter == undefined) //Playing on main effect bus, no emitter needed
                {
                    __instance = audio_play_sound(__sound, 1, __loop, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
                }
                else
                {
                    __instance = audio_play_sound_on(_effectChainEmitter, __sound, __loop, 1, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
                }
                
                if (VINYL_DEBUG_LEVEL >= 1)
                {
                    __VinylTrace("Playing ", self, ", loop=", __loop? "true" : "false", ", gain in=", __gainInput, "/out=", __gainOutput, ", pitch=", __pitchOutput, ", label=", __VinylDebugLabelNames(__sound), " (GMinst=", __instance, ", amplitude=", __gainOutput/VINYL_MAX_GAIN, ")");
                }
            }
            else
            {
                //Playback on a pan emitter
                __panEmitter = __poolPanEmitter.__Depool();
                __panEmitter.__Pan(_pan);
                __panEmitter.__Bus(__effectChainName);
                
                __instance = audio_play_sound_on(__panEmitter.__emitter, __sound, __loop, 1, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
                
                if (VINYL_DEBUG_LEVEL >= 1)
                {
                    __VinylTrace("Playing ", self, " on pan emitter ", __panEmitter, ", loop=", __loop? "true" : "false", ", gain in=", __gainInput, "/out=", __gainOutput, ", pitch=", __pitchOutput, ", label=", __VinylDebugLabelNames(__sound), " (GMinst=", __instance, ", amplitude=", __gainOutput/VINYL_MAX_GAIN, ")");
                }
            }
        }
        else
        {
            //Playback on a normal emitter
            __instance = audio_play_sound_on(_emitter.__GetEmitter(), __sound, __loop, 1, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
            array_push(_emitter.__emitter.__instanceIDArray, __id);
            
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace("Playing ", self, " on emitter ", _emitter, ", loop=", __loop? "true" : "false", ", gain in=", __gainInput, "/out=", __gainOutput, ", pitch=", __pitchOutput, ", label=", __VinylDebugLabelNames(__sound), " (GMinst=", __instance, ", amplitude=", __gainOutput/VINYL_MAX_GAIN, ")");
            }
        }
        
        //Finalise the instance with loop points if necessary
        __LoopPointsSet();
        
        if (__gainOutput > VINYL_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value ", __gainOutput, " exceeds VINYL_MAX_GAIN (", VINYL_MAX_GAIN, ")");
        }
        
        return __instance;
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __Pause = function()
    {
        if (!is_numeric(__instance)) return;
        if (audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", self);
        
        audio_pause_sound(__instance);
    }
    
    static __Resume = function()
    {
        if (!is_numeric(__instance)) return;
        if (!audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", self);
        
        audio_resume_sound(__instance);
    }
    
    static __FadeOut = function(_rate)
    {
        __GainTargetSet(0, _rate, true);
    }
    
    static __Stop = function()
    {
        if (!is_numeric(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", self);
        
        audio_stop_sound(__instance);
        __instance = undefined;
        
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
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " using ", __panEmitter, ", pooling it");
            
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
        if (!is_numeric(__instance)) return;
        
        if (!audio_is_playing(__instance))
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
                
                if (VINYL_DEBUG_LEVEL >= 2)
                {
                    __VinylTrace("Updated ", self, ", loop=", __loop? "true" : "false", ", gain in=", __gainInput, "/out=", __gainOutput, ", pitch=", __pitchOutput, ", label=", __VinylDebugLabelNames(__sound), " (GMinst=", __instance, ", amplitude=", __gainOutput/VINYL_MAX_GAIN, ")");
                }
                
                audio_sound_gain(__instance, __VinylCurveAmplitude(__gainOutput), VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __pitchOutput);
            }
        }
    }
}