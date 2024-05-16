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
    static _voiceLookUpMap    = __VinylSystem().__voiceLookUpMap;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    
    __inUpdateArray = false;
    
    __sound        = _sound;
    __voice        = _voice;
    __loopLocal    = _loopLocal;
    
    __gainSound    = __VinylSoundGetGain(_sound);
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
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
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
            audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
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
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __QueueUpdateForSound = function(_sound)
    {
        if (__sound == _sound) array_push(_toUpdateArray, self);
    }
    
    static __UpdateFromPattern = function()
    {
        var _pattern = __pattern;
        
        __gainSound = __VinylSoundGetGain(__sound);
        
        __gainPattern  = lerp(_pattern.__gainMin,  _pattern.__gainMax,  __gainFactor);
        __pitchPattern = lerp(_pattern.__pitchMin, _pattern.__pitchMax, __pitchFactor);
        
        var _mixStruct = __VinylVoiceMoveMix(__voice, _pattern.__mixName);
        var _loopMix = (_mixStruct == undefined)? undefined : _mixStruct.__membersLoop;
        
        audio_sound_loop( __voice, __loopLocal ?? (_pattern.__loop ?? _loopMix));
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_SxPxLxMxF/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_SxPxL);
    }
}