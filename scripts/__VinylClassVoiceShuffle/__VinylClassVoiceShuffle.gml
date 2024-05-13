// Feather disable all

/// @param sound
/// @param voice
/// @param loopLocal
/// @param gainPattern
/// @param gainLocal
/// @param gainMix
/// @param pitchPattern
/// @param pitchLocal
/// @param pattern
/// @param gainFactor
/// @param pitchFactor

function __VinylClassVoiceShuffle(_sound, _voice, _loopLocal, _gainPattern, _gainLocal, _gainMix, _pitchPattern, _pitchLocal, _pattern, _gainFactor, _pitchFactor) constructor
{
    static _voiceLookUpDict   = __VinylSystem().__voiceLookUpDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    __inUpdateArray = false;
    
    __sound        = _sound;
    __voice        = _voice;
    __loopLocal    = _loopLocal;
    __gainPattern  = _gainPattern;
    __gainLocal    = _gainLocal;
    __gainMix      = _gainMix;
    __pitchPattern = _pitchPattern;
    __pitchLocal   = _pitchLocal;
    __pattern      = _pattern;
    __mixName      = (_pattern != undefined)? _pattern.__mixName : undefined;
    __gainFactor   = _gainFactor;
    __pitchFactor  = _pitchFactor;
    
    __gainLocalTarget  = _gainLocal;
    __gainLocalSpeed   = infinity;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    array_push(_voiceCleanUpArray, self);
    struct_set_from_hash(_voiceLookUpDict, int64(_voice), self);
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", _voice, " to voice lookup struct");
    
    
    
    
    
    static __IsPlaying = function()
    {
        return audio_is_playing(__voice);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voice);
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__voice);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__voice);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__voice);
    }
    
    static __Update = function(_delta)
    {
        var _changed = false;
        
        if (__gainFadeOutSpeed != undefined)
        {
            _changed = true;
            __gainFadeOut -= __gainFadeOutSpeed*_delta;
            
            if (__gainFadeOut <= 0)
            {
                __Stop();
                return false;
            }
        }
        
        if (__gainLocal != __gainLocalTarget)
        {
            _changed = true;
            __gainLocal += _delta*clamp(__gainLocalTarget - __gainLocal, -__gainLocalSpeed, __gainLocalSpeed);
        }
        
        if (_changed)
        {
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        }
        
        return true;
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (not __inUpdateArray)
        {
            __inUpdateArray = true;
            array_push(_voiceUpdateArray, self);
        }
        
        __gainFadeOutSpeed = _rateOfChange;
    }
    
    static __SetLoop = function(_state)
    {
        audio_sound_loop(__voice, _state);
    }
    
    static __GetLoop = function()
    {
        return audio_sound_get_loop(__voice);
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        }
        else
        {
            if (not __inUpdateArray)
            {
                __inUpdateArray = true;
                array_push(_voiceUpdateArray, self);
            }
        }
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetFromSound = function(_sound, _gain, _pitch, _loop, _mixName)
    {
        if (__sound != _sound) return;
        
        __gainSound  = _gain;
        __pitchSound = _pitch;
        
        __VinylVoiceMoveMix(__voice, _mixName);
        
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetFromPattern = function(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mixName)
    {
        __gainPattern  = lerp(_gainMin,  _gainMax,  __gainFactor);
        __pitchPattern = lerp(_pitchMin, _pitchMax, __pitchFactor);
        
        __VinylVoiceMoveMix(__voice, _mixName);
        
        audio_sound_loop( __voice, __loopLocal ?? _loop);
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_EQUATION);
    }
}