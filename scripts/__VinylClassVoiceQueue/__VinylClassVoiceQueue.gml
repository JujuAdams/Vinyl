// Feather disable all

/// @param behaviour
/// @param loopQueue
/// @param localGain

function __VinylClassVoiceQueue(_behaviour, _loopQueue, _gainLocal) constructor
{
    static _queueCount = 0;
    
    static _soundDict        = __VinylSystem().__soundDict;
    static _voiceLookUpDict  = __VinylSystem().__voiceLookUpDict;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    
    __gainPattern  = 1;
    __gainLocal = _gainLocal;
    __gainMix   = 1;
    
    __mixName = undefined;
    
    __gainLocalTarget = _gainLocal;
    __gainLocalSpeed  = infinity;
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    __destroyed        = false;
    
    __voiceCurrent = -1;
    __soundCurrent = undefined;
    __soundArray   = [];
    __behaviour    = _behaviour;
    __loopQueue    = _loopQueue;
    
    __voiceReference = 0x66606660_00000000 | _queueCount;
    ++_queueCount;
    
    //Add the generated voice to the mix's array of voices
    array_push(_voiceUpdateArray, self);
    struct_set_from_hash(_voiceLookUpDict, int64(__voiceReference), self);
    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", __voiceReference, " to voice lookup struct");
    
    
    
    
    
    static __Update = function(_delta)
    {
        if (__destroyed) return false;
        
        var _changed = false;
        
        if (__gainFadeOutSpeed != undefined)
        {
            __gainFadeOut -= _delta*__gainFadeOutSpeed;
            if (__gainFadeOut <= 0)
            {
                __Destroy();
                return false;
            }
            
            _changed = true;
        }
        
        if (__gainLocal != __gainLocalTarget)
        {
            _changed = true;
            __gainLocal += _delta*clamp(__gainLocalTarget - __gainLocal, -__gainLocalSpeed, __gainLocalSpeed);
        }
        
        if ((array_length(__soundArray) > 0) && VinylWillStop(__voiceCurrent))
        {
            var _sound = array_pop(__soundArray);
            
            switch(__behaviour)
            {
                case VINYL_QUEUE.DONT_LOOP:
                    var _loop = false;
                break;
                
                case VINYL_QUEUE.LOOP_ON_LAST:
                    var _loop = (array_length(__soundArray) <= 0);
                break;
                
                case VINYL_QUEUE.LOOP_EACH:
                    var _loop = true;
                break;
            }
            
            if (__loopQueue && (__soundCurrent != undefined)) array_push(__soundArray, __soundCurrent);
            
            __VinylVoiceMoveMix(__voiceReference, struct_get_from_hash(_soundDict, int64(_sound)).__mixName);
            
            __soundCurrent = _sound;
            __voiceCurrent = audio_play_sound(_sound, 0, _loop, __VINYL_VOICE_GAIN_EQUATION_INC_SOUND/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
        }
        else
        {
            if (_changed)
            {
                audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION_INC_SOUND/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
            }
        }
        
        return true;
    }
    
    static __IsPlaying = function()
    {
        return (__voiceCurrent >= 0);
    }
    
    static __Stop = function()
    {
        audio_stop_sound(__voiceCurrent);
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__voiceCurrent);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__voiceCurrent);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__voiceCurrent);
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        __gainFadeOutSpeed = _rateOfChange;
    }
    
    static __SetLoop = function(_state)
    {
        audio_sound_loop(__voiceCurrent, _state);
    }
    
    static __GetLoop = function()
    {
        return audio_sound_get_loop(__voiceCurrent);
    }
    
    static __SetLocalGain = function(_gain, _rateOfChange)
    {
        __gainLocalTarget = _gain;
        __gainLocalSpeed  = _rateOfChange;
        
        if (_rateOfChange > 100)
        {
            __gainLocal = _gain;
            audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION_INC_SOUND/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
        }
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = max(0, _gain);
        audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION_INC_SOUND/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetBehaviour = function(_behaviour, _setForPlaying)
    {
        __behaviour = _behaviour;
        
        if (_setForPlaying)
        {
            switch(_behaviour)
            {
                case VINYL_QUEUE.DONT_LOOP:
                    audio_sound_loop(__voiceCurrent, false);
                break;
                
                case VINYL_QUEUE.LOOP_ON_LAST:
                    audio_sound_loop(__voiceCurrent, (array_length(__soundArray) <= 0));
                break;
                
                case VINYL_QUEUE.LOOP_EACH:
                    audio_sound_loop(__voiceCurrent, true);
                break;
            }
        }
    }
    
    static __SetFromSound = function(_sound)
    {
        
    }
    
    static __Destroy = function()
    {
        __Stop();
        __destroyed = true;
    }
}