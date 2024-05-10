// Feather disable all

/// @param voice
/// @param loopLocal
/// @param gainBase
/// @param gainLocal
/// @param gainMix
/// @param pitchBase
/// @param pitchLocal
/// @param [pattern]
/// @param [gainFactor]
/// @param [pitchFactor]

function __VinylClassVoiceSound(_voice, _loopLocal, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, _pattern, _gainFactor, _pitchFactor) constructor
{
    static _voiceStructDict   = __VinylSystem().__voiceStructDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    array_push(_voiceCleanUpArray, self);
    struct_set_from_hash(_voiceStructDict, int64(_voice), self);
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", _voice, " to voice lookup struct");
    
    __voice      = _voice;
    __loopLocal  = _loopLocal;
    __gainBase   = _gainBase;
    __gainLocal  = _gainLocal;
    __gainMix    = _gainMix;
    __pitchBase  = _pitchBase;
    __pitchLocal = _pitchLocal;
    
    if (VINYL_LIVE_EDIT)
    {
        __pattern     = _pattern;
        __mixName     = (_pattern != undefined)? _pattern.__mixName : undefined;
        __gainFactor  = _gainFactor;
        __pitchFactor = _pitchFactor;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    
    
    
    
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
        __gainFadeOut -= __gainFadeOutSpeed*_delta;
        if (__gainFadeOut <= 0)
        {
            __Stop();
            return false;
        }
        
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
        return true;
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        if (__gainFadeOutSpeed == undefined) array_push(_voiceUpdateArray, self);
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = max(0, _gain);
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        audio_sound_gain(__voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetFromPattern = function(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix)
    {
        __gainBase  = lerp(__gainMin,  __gainMax,  __gainFactor);
        __pitchBase = lerp(__pitchMin, __pitchMax, __pitchFactor);
        
        if (_mix == undefined)
        {
            __gainMix = 1;
        }
        else
        {
            if (__mixName != _mix)
            {
                if (__mixName != undefined)
                {
                    var _oldMixStruct = _mixDict[$ __mixName];
                    if (_oldMixStruct != undefined) _oldMixStruct.__Remove(__voice);
                }
                
                __mixName = _mix;
            }
            
            var _mixStruct = _mixDict[$ __mixName];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", __mixName, "\" not recognised");
                return;
            }
            
            __gainMix = _mixStruct.__gainFinal;
            _mixStruct.__Add(__voice);
        }
        
        audio_sound_loop( __voice, _loop ?? __loopLocal);
        audio_sound_gain( __voice, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_GAIN, VINYL_STEP_DURATION);
        audio_sound_pitch(__voice, __VINYL_VOICE_PITCH_EQUATION);
    }
}