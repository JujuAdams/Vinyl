function __VinylClassVoiceAsset() : __VinylClassVoiceCommon() constructor
{
    __StateReset();
    
    static __patternType = "asset";
    
    static toString = function()
    {
        if (__pattern == undefined)
        {
            return "<asset " + string(__id) + ">";
        }
        else if (is_string(__sound) || is_undefined(__sound))
        {
            return "<asset " + string(__id) + " " + __pattern.__name + ">";
        }
        else
        {
            return "<asset " + string(__id) + " " + audio_get_name(__sound) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
        
        __sound      = undefined;
        __gmInstance = undefined;
        
        __bpm            = VINYL_DEFAULT_BPM;
        __bpmBeat        = 0;
        __bpmBeatCounter = 0;
        __bpmPulse       = false;
        
        __paused     = false;
        __duckPaused = false;
    }
    
    static __Instantiate = function(_pattern, _parentVoice, _vinylEmitter, _sound, _loop, _gain, _pitch, _pan)
    {
        //Set the sound first so that error message make more sense
        __sound = _sound;
        
        __StateSetCommon(_pattern, _parentVoice, _vinylEmitter, _loop, _gain, _pitch, _pan);
        
        __bpm = __pattern.__bpm;
        
        __Play();
        
    }
    
    static __Play = function()
    {
        var _gmEmitter = (__vinylEmitter == undefined)? undefined : __vinylEmitter.__GetEmitter();
        if (_gmEmitter == undefined)
        {
            __gmInstance = audio_play_sound(__sound, 1, __loopOutput, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " playing ", __gmInstance, ", loop=", __loopOutput? "true" : "false", ", gain=", __gainOutput, ", pitch=", __pitchOutput, ", persistent=", __persistent);
        }
        else
        {
            __gmInstance = audio_play_sound_on(_gmEmitter, __sound, __loopOutput, 1, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " playing ", __gmInstance, " on GM emitter ", _gmEmitter, ", loop=", __loopOutput? "true" : "false", ", gain=", __gainOutput, ", pitch=", __pitchOutput, ", persistent=", __persistent);
        }
    }
    
    static __Replay = function()
    {
        var _position = audio_sound_get_track_position(__gmInstance);
        audio_stop_sound(__gmInstance);
        __Play();
        audio_sound_set_track_position(__gmInstance, _position);
    }
    
    static __Migrate = function()
    {
        if (__pattern.__name == "fallback")
        {
            __pattern = __VinylPatternGet(__sound);
        }
        else
        {
            var _pattern = __VinylPatternGetUnsafe(__pattern.__name);
            if (_pattern == undefined) __VinylTrace("Warning! Asset definition for ", audio_get_name(__sound), " no longer exists in configuration file. ", self, " now using fallback asset properties");
            __pattern = __VinylPatternGet(__sound);
        }
        
        var _oldEmitter = __vinylEmitter;
        var _oldLoopOutput = __loopOutput;
        
        __MigrateCommon();
        
        if (_oldLoopOutput != __loopOutput)
        {
            if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Loop state changed, replaying ", self);
            __Replay();
        }
        else if (_oldEmitter != __vinylEmitter)
        {
            if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Emitter changed, replaying ", self);
            __Replay();
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        __bpmPulse = false;
        
        if (__IsPlaying())
        {
            __TickCommon(_deltaTimeFactor);
            
            if (__gmInstance != undefined) //Instance can be destroyed in __TickCommon()
            {
                audio_sound_gain(__gmInstance, __VinylCurveAmplitude(__gainOutput), VINYL_STEP_DURATION);
                audio_sound_pitch(__gmInstance, __pitchOutput);
                
                var _beat = floor(audio_sound_get_track_position(__gmInstance) / (60 / __bpm));
                if (_beat != __bpmBeat)
                {
                    __bpmPulse = true;
                    __bpmBeat = _beat;
                    ++__bpmBeatCounter;
                }
            }
        }
        else
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
    }
    
    
    
    #region BPM
    
    static __BPMGet = function()
    {
        return __bpm;
    }
    
    static __BPMPulseGet = function()
    {
        return __bpmPulse;
    }
    
    static __BPMBeatCountGet = function()
    {
        return __bpmPulse;
    }
    
    #endregion
    
    
    
    #region Loop
    
    static __LoopSet = function(_state)
    {
        if (__loopLocal != _state)
        {
            __loopLocal = _state;
            
            var _oldLoopOutput = __loopOutput;
            __LoopResolve();
            
            if (_oldLoopOutput != __loopOutput)
            {
                if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Loop state changed, replaying ", self);
                __Replay();
            }
        }
    }
    
    #endregion
    
    
    
    #region Playback
    
    static __IsPlaying = function()
    {
        if (!is_numeric(__gmInstance)) return false;
        return audio_is_playing(__gmInstance);
    }
    
    static __Pause = function()
    {
        if (!is_numeric(__gmInstance) || __paused) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", self);
        
        __paused = true;
        audio_pause_sound(__gmInstance);
    }
    
    static __PauseGet = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        return __paused;
    }
    
    static __Resume = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (__paused)
        {
            __paused = false;
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", self);
            
            if (!__duckPaused) audio_resume_sound(__gmInstance);
        }
    }
    
    static __PauseDuck = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", self, " (via stack)");
        
        __duckPaused = true;
        audio_pause_sound(__gmInstance);
    }
    
    static __ResumeDuck = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (__duckPaused)
        {
            __duckPaused = false;
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", self, " (via stack)");
            
            if (!__paused) audio_resume_sound(__gmInstance);
        }
    }
    
    static __Stop = function()
    {
        if (__gmInstance == undefined) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", self);
        
        __StopCallbackExecute();
        
        audio_stop_sound(__gmInstance);
        __gmInstance = undefined;
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (!is_numeric(__gmInstance)) return 0;
        return audio_sound_length(__gmInstance);
    }
    
    static __PositionSet = function(_position)
    {
        if (!is_numeric(__gmInstance)) return;
        audio_sound_set_track_position(__gmInstance, _position);
    }
    
    static __PositionGet = function()
    {
        if (!is_numeric(__gmInstance)) return 0;
        return audio_sound_get_track_position(__gmInstance);
    }
    
    #endregion
}