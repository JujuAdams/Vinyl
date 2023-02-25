function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "basic";
    
    static toString = function()
    {
        if (__pattern == undefined)
        {
            return "<basic " + string(__id) + ">";
        }
        else if (is_string(__sound))
        {
            return "<basic " + string(__id) + " " + __pattern.__name + ">";
        }
        else
        {
            return "<basic " + string(__id) + " " + audio_get_name(__sound) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
        
        __sound      = undefined;
        __gmInstance = undefined;
    }
    
    static __Instantiate = function(_pattern, _parentInstance, _vinylEmitter, _sound, _loop, _gain, _pitch, _pan)
    {
        __StateSetCommon(_pattern, _parentInstance, _vinylEmitter, _loop, _gain, _pitch, _pan);
        __sound = _sound;
        __Play();
        
    }
    
    static __Play = function()
    {
        var _gmEmitter = (__vinylEmitter == undefined)? undefined : __vinylEmitter.__GetEmitter();
        if (_gmEmitter == undefined)
        {
            __gmInstance = audio_play_sound(__sound, 1, __loop, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " playing ", __gmInstance, ", loop=", __loop? "true" : "false", ", gain=", __gainOutput, ", pitch=", __pitchOutput);
        }
        else
        {
            __gmInstance = audio_play_sound_on(_gmEmitter, __sound, __loop, 1, __VinylCurveAmplitude(__gainOutput), 0, __pitchOutput);
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " playing ", __gmInstance, " on GM emitter ", _gmEmitter, ", loop=", __loop? "true" : "false", ", gain=", __gainOutput, ", pitch=", __pitchOutput);
        }
        
        __LoopPointsSet();
        
        if (__gainOutput > VINYL_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value for ", self, " (", __gainOutput, ") exceeds VINYL_MAX_GAIN (", VINYL_MAX_GAIN, ")");
        }
    }
    
    static __Migrate = function()
    {
        var _oldEmitter = __vinylEmitter;
        
        __MigrateCommon();
        
        if (_oldEmitter != __vinylEmitter)
        {
            var _position = audio_sound_get_track_position(__gmInstance);
            audio_stop_sound(__gmInstance);
            __Play();
            audio_sound_set_track_position(__gmInstance, _position);
        }
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (__IsPlaying())
        {
            __TickCommon(_deltaTimeFactor);
            
            if (__gmInstance != undefined)
            {
                audio_sound_gain(__gmInstance, __VinylCurveAmplitude(__gainOutput), VINYL_STEP_DURATION);
                audio_sound_pitch(__gmInstance, __pitchOutput);
            }
        }
        else
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
    }
    
    
    
    #region Loop
    
    static __LoopSet = function(_state)
    {
        __loop = _state;
        audio_sound_loop(__gmInstance, _state);
    }
    
    static __LoopPointsSet = function()
    {
        if (__pattern != undefined)
        {
            var _loopPoints = __pattern.__loopPoints;
            if (is_array(_loopPoints))
            {
                audio_sound_loop_start(__gmInstance, _loopPoints[0]);
                audio_sound_loop_end(  __gmInstance, _loopPoints[1]);
            }
            else
            {
                audio_sound_loop_start(__gmInstance, 0);
                audio_sound_loop_end(  __gmInstance, audio_sound_length(__gmInstance));
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
        if (!is_numeric(__gmInstance)) return;
        if (audio_is_paused(__gmInstance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pausing ", self);
        
        audio_pause_sound(__gmInstance);
    }
    
    static __PauseGet = function()
    {
        if (!is_numeric(__gmInstance)) return;
        if (audio_is_paused(__gmInstance)) return;
        
        return audio_is_paused(__gmInstance);
    }
    
    static __Resume = function()
    {
        if (!is_numeric(__gmInstance)) return;
        if (!audio_is_paused(__gmInstance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Resuming ", self);
        
        audio_resume_sound(__gmInstance);
    }
    
    static __Stop = function()
    {
        if (__gmInstance == undefined) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", self);
        
        audio_stop_sound(__gmInstance);
        __gmInstance = undefined;
        
        __VINYL_RETURN_SELF_TO_POOL
    }
    
    static __LengthGet = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (audio_sound_get_loop(__gmInstance))
        {
            return audio_sound_get_loop_end(__gmInstance) - audio_sound_get_loop_start(__gmInstance);
        }
        else
        {
            return audio_sound_length(__gmInstance);
        }
    }
    
    static __PositionSet = function(_position)
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (audio_sound_get_loop(__gmInstance))
        {
            audio_sound_set_track_position(__gmInstance, _position + audio_sound_get_loop_start(__gmInstance));
        }
        else
        {
            audio_sound_set_track_position(__gmInstance, _position);
        }
    }
    
    static __PositionGet = function()
    {
        if (!is_numeric(__gmInstance)) return;
        
        if (audio_sound_get_loop(__gmInstance))
        {
            return audio_sound_get_track_position(__gmInstance) - audio_sound_get_loop_start(__gmInstance);
        }
        else
        {
            return audio_sound_get_track_position(__gmInstance);
        }
    }
    
    #endregion
}