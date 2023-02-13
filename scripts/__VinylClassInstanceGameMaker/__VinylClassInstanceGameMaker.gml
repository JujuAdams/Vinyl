function __VinylClassInstanceGameMaker() constructor
{
    static toString = function()
    {
        if (__sound == undefined)
        {
            return "<gm " + string(__instance) + ">";
        }
        else
        {
            return "<gm " + string(__instance) + " " + string(audio_get_name(__sound)) + ">";
        }
    }
    
    static __GainSet = function(_gain)
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (audio_sound_get_gain(__instance) != _gain)) __VinylTrace(self, " gain=", audio_sound_get_gain(__instance), " -> ", _gain);
        
        audio_sound_gain(__instance, __VinylCurveAmplitude(_gain), VINYL_STEP_DURATION);
    }
    
    static __PitchSet = function(_pitch)
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (audio_sound_get_pitch(__instance) != _pitch)) __VinylTrace(self, " pitch=", audio_sound_get_pitch(__instance), " -> ", _pitch);
        
        audio_sound_pitch(__instance, _pitch);
    }
    
    static __LoopSet = function(_state)
    {
        audio_sound_loop(__instance, _state);
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
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch)
    {
        __sound = _sound;
        
        if (_emitter == undefined)
        {
            __instance = audio_play_sound(_sound, 1, _loop, __VinylCurveAmplitude(_gain), 0, _gain);
            
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace("Playing ", self, ", loop=", _loop? "true" : "false", ", gain=", _gain, ", pitch=", _gain, " (amplitude=", _gain/VINYL_MAX_GAIN, ")");
            }
        }
        else
        {
            __instance = audio_play_sound_on(_emitter, _sound, _loop, 1, __VinylCurveAmplitude(_gain), 0, _gain);
            
            if (VINYL_DEBUG_LEVEL >= 1)
            {
                __VinylTrace("Playing ", self, " on emitter ", _emitter, ", loop=", _loop? "true" : "false", ", gain=", _gain, ", pitch=", _gain, " (amplitude=", _gain/VINYL_MAX_GAIN, ")");
            }
        }
        
        __LoopPointsSet();
        
        if (_gain > VINYL_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value ", _gain, " exceeds VINYL_MAX_GAIN (", VINYL_MAX_GAIN, ")");
        }
    }
    
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
    
    static __Stop = function()
    {
        if (!is_numeric(__instance)) return;
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Stopping ", self);
        
        audio_stop_sound(__instance);
        
        __sound    = undefined;
        __instance = undefined;
    }
}