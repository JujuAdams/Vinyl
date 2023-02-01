function __VinylClassBasicInstance() constructor
{
    __id = undefined;
    __pooled = true;
    
    __ResetState();
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for instance ", __id);
        
        __sound      = undefined;
        __loop       = undefined;
        __inputGain  = 0.0;
        __inputPitch = 100;
        
        __transposeUsing     = false;
        __transposeSemitones = 0;
        __transposePitch     = 1; //Internal value, stored as normalized percentage
        
        __shutdown = false;
        
        __gainTarget  = __inputGain;
        __gainRate    = VINYL_DEFAULT_GAIN_RATE;
        __pitchTarget = __inputPitch;
        __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
        
        __randomPitchParam = 0.5;
        
        __outputChanged = false;
        __outputGain    = 0.0;
        __outputPitch   = 100;
        
        __instance = undefined;
        __emitter  = undefined;
    }
    
    
    
    #region Gain
    
    static __InputGainSet = function(_gain)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " gain=", _gain);
        }
        
        __inputGain  = _gain;
        __gainTarget = _gain;
    }
    
    static __InputGainTargetSet = function(_targetGain, _rate, _stopAtSilence = false)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set gain target for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " gain target=", _targetGain, ", rate=", _rate, "/s, stop at silence=", _stopAtSilence? "true" : "false");
        }
        
        __gainTarget = _targetGain;
        __gainRate   = _rate;
        __shutdown   = _stopAtSilence;
    }
    
    static __FadeOut = function(_rate)
    {
        __InputGainTargetSet(0, _rate, true);
    }
    
    #endregion
    
    
    
    #region Pitch
    
    static __InputPitchSet = function(_pitch)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " pitch=", _pitch);
        }
        
        __inputPitch  = _pitch;
        __pitchTarget = _pitch;
    }
    
    static __InputPitchTargetSet = function(_targetPitch, _rate)
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot set pitch target for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " pitch target=", _targetPitch, ", rate=", _rate, "/s");
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
            __VinylTrace("Cannot set transposition for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (__transposeSemitones != _semitones)
        {
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " transposition=", _semitones);
            }
            
            __transposeUsing = true;
            
            __transposePitch     = __VinylSemitoneToPitch(_semitones + global.__vinylTransposeSemitones);
        }
    }
    
    static __TransposeReset = function()
    {
        if (__shutdown)
        {
            __VinylTrace("Cannot reset transposition for instance ", __id, " (playing ", audio_get_name(__sound), "), it is set to shut down");
            return;
        }
        
        if (__transposeUsing)
        {
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " transposition=0");
            }
            
            __outputPitch /= __transposePitch;
            
            __transposeUsing     = false;
            __transposeSemitones = 0;
            __transposePitch     = 1;
            
            __outputChanged = true;
        }
    }
    
    #endregion
    
    
    
    static __PlaySetState = function(_sound, _loop, _gain, _pitch)
    {
        __sound      = _sound;
        __loop       = _loop ?? __GetLoopFromLabel();
        __inputGain  = _gain;
        __inputPitch = _pitch;
        
        __gainTarget  = __inputGain;
        __pitchTarget = __inputPitch;
        
        __randomPitchParam = __VinylRandom(1);
        __ApplyLabel(true);
    }
       
    static __Play = function(_sound, _loop, _gain, _pitch)
    { 
        __PlaySetState(_sound, _loop, _gain, _pitch);
        
        __instance = audio_play_sound(__sound, 1, __loop, __VinylCurveAmplitude(__outputGain), 0, __outputPitch);
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, "/out=", __outputGain, ", pitch=", __outputPitch, ", label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", __outputGain/VINYL_SYSTEM_MAX_GAIN, ")");
        }
        
        if (__outputGain > VINYL_SYSTEM_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value ", __outputGain, " exceeds VINYL_SYSTEM_MAX_GAIN (", VINYL_SYSTEM_MAX_GAIN, ")");
        }
    }
    
    static __PlayOnEmitter = function(_sound, _loop, _gain, _pitch, _emitter)
    {
        __PlaySetState(_sound, _loop, _gain, _pitch);
        
        __emitter = _emitter ?? __VinylDepoolEmitter();
        
        __instance = audio_play_sound_on(__emitter, __sound, __loop, 1, __VinylCurveAmplitude(__outputGain), 0, __outputPitch);
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Instance ", __id, " playing ", audio_get_name(__sound), " on emitter ", __emitter, ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, "/out=", __outputGain, ", pitch=", __outputPitch, ", label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", __outputGain/VINYL_SYSTEM_MAX_GAIN, ")");
        }
        
        if (__outputGain > VINYL_SYSTEM_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value ", __outputGain, " exceeds VINYL_SYSTEM_MAX_GAIN (", VINYL_SYSTEM_MAX_GAIN, ")");
        }
    }
    
    static __GetLoopFromLabel = function()
    {
        var _asset = __VinylPatternGet(__sound);
        return is_struct(_asset)? _asset.__GetLoopFromLabel() : false;
    }
    
    static __ApplyLabel = function(_initialize)
    {
        //Update the output values based on the asset and labels
        __outputGain  = __inputGain;
        __outputPitch = __inputPitch;
        
        var _asset = __VinylPatternGet(__sound);
        if (is_struct(_asset))
        {
            __outputGain *= _asset.__gain;
            var _assetPitch = lerp(_asset.__pitchLo, _asset.__pitchHi, __randomPitchParam);
            __outputPitch *= _assetPitch;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                
                __outputGain *= _label.__outputGain;
                var _labelPitch = lerp(_label.__configPitchLo, _label.__configPitchHi, __randomPitchParam);
                __outputPitch *= _labelPitch*_label.__outputPitch;
                
                if (_initialize) _label.__AddInstance(__id);
                
                ++_i;
            }
        }
    }
    
    static __Pause = function()
    {
        if (!is_numeric(__instance)) return;
        if (audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing instance ", __id, " playing ", audio_get_name(__sound), " (GMinst=", __instance, ")");
        
        audio_pause_sound(__instance);
    }
    
    static __Resume = function()
    {
        if (!is_numeric(__instance)) return;
        if (!audio_is_paused(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming instance ", __id, " playing ", audio_get_name(__sound), " (GMinst=", __instance, ")");
        
        audio_resume_sound(__instance);
    }
    
    static __Stop = function()
    {
        if (__instance == undefined) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Forcing instance ", __id, " to stop (GMinst=", __instance, ")");
        
        audio_stop_sound(__instance);
        __instance = undefined;
        
        __Pool();
    }
    
    static __Depool = function(_id)
    {
        if (!__pooled) return;
        __pooled = false;
        
        __id = _id;
        global.__vinylIdToInstanceDict[? _id] = self;
        array_push(global.__vinylBasicPlaying, self);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Depooling an instance as ID ", __id);
    }
    
    static __Pool = function()
    {
        if (__pooled) return;
        __pooled = true;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pooling instance ", __id);
        
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
        
        ds_map_delete(global.__vinylIdToInstanceDict, __id);
        
        //Move this instance to the "return" array
        //This prevents an instance being pooled and depooled in the same step
        //which would lead to problems with labels tracking what they're playing
        array_push(global.__vinylBasicPoolReturn, self);
        
        if (__emitter != undefined)
        {
            array_push(global.__vinylEmitterPoolReturn, __emitter);
            __emitter = undefined;
        }
        
        __id = undefined;
    }
    
    static __Tick = function(_deltaTime)
    {
        if (!audio_is_playing(__instance))
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Instance ", __id, " has stopped played, returning to pool");
            __Pool();
        }
        else
        {
            var _delta = clamp(__gainTarget - __inputGain, -_deltaTime*__gainRate, _deltaTime*__gainRate);
            if (_delta != 0)
            {
                __inputGain  += _delta;
                __outputGain += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta < 0) && ((__inputGain <= 0) || (__outputGain <= 0)))
                {
                    __Stop();
                    return;
                }
            }
            
            var _delta = clamp(__pitchTarget - __inputPitch, -_deltaTime*__pitchRate, _deltaTime*__pitchRate);
            if (_delta != 0)
            {
                __inputPitch  += _delta;
                __outputPitch += _delta;
                __outputChanged = true;
            }
            
            if (__outputChanged)
            {
                __outputChanged = false;
                
                if (VINYL_DEBUG_LEVEL >= 2)
                {
                    __VinylTrace("Updated instance ", __id, " playing ", audio_get_name(__sound), ", loop=", __loop? "true" : "false", ", gain in=", __inputGain, "/out=", __outputGain, ", pitch=", __outputPitch, ", label=", __DebugLabelNames(), " (GMinst=", __instance, ", amplitude=", __outputGain/VINYL_SYSTEM_MAX_GAIN, ")");
                }
                
                audio_sound_gain(__instance, __VinylCurveAmplitude(__outputGain), VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __outputPitch);
            }
        }
    }
    
    static __DebugLabelNames = function()
    {
        var _asset = __VinylPatternGet(__sound);
        return is_struct(_asset)? _asset.__DebugLabelNames() : "";
    }
}