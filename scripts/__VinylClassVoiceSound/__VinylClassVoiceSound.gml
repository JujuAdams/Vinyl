// Feather disable all

/// @param voice
/// @param loopLocal
/// @param gainSound
/// @param gainLocal
/// @param gainMix
/// @param pitchSound
/// @param pitchLocal
/// @param pattern

function __VinylClassVoiceSound(_voice, _loopLocal, _gainSound, _gainLocal, _gainMix, _pitchSound, _pitchLocal, _pattern) constructor
{
    static _soundDict         = __VinylSystem().__soundDict;
    static _voiceLookUpMap    = __VinylSystem().__voiceLookUpMap;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    
    __inUpdateArray = false;
    
    __voice        = _voice;
    __gainSound    = _gainSound;
    __gainLocal    = _gainLocal;
    __gainMix      = _gainMix;
    __pitchSound   = _pitchSound;
    __pitchLocal   = _pitchLocal;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern = _pattern;
        
        __loopLocal = _loopLocal;
        __sound     = _pattern.__sound;
        __mixName   = _pattern.__mixName;
    }
    
    __gainLocalTarget  = _gainLocal;
    __gainLocalSpeed   = infinity;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    array_push(_voiceCleanUpArray, self);
    _voiceLookUpMap[? _voice] = self;
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
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
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
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
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
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __QueueUpdateForSound = function(_sound)
    {
        if (__sound == _sound) array_push(_toUpdateArray, self);
    }
    
    static __UpdateFromPattern = function()
    {
        var _pattern = struct_get_from_hash(_soundDict, int64(__sound));
        
        __gainSound  = _pattern.__gain;
        __pitchSound = _pattern.__pitch;
        
        __VinylVoiceMoveMix(__voice, _pattern.__mixName);
        
        audio_sound_loop( __voice, __loopLocal ?? _pattern.__loop);
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_SxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_SxL);
    }
}