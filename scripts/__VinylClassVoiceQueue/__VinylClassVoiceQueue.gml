// Feather disable all

/// @param behaviour
/// @param loopQueue
/// @param localGain
/// @param mix

function __VinylClassVoiceQueue(_behaviour, _loopQueue, _gainLocal, _mix) constructor
{
    static _queueCount = 0;
    
    static _mixDict           = __VinylSystem().__mixDict;
    static _voiceLookUpDict   = __VinylSystem().__voiceLookUpDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    __gainBase  = 1;
    __gainLocal = _gainLocal;
    
    __mixName = _mix;
    __noMix   = ((_mix == undefined) || (_mix == VINYL_NO_MIX));
    
    if (__noMix)
    {
        var _mixStruct = undefined;
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ __mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", __mixName, "\" not recognised");
            return;
        }
        
        __gainMix = _mixStruct.__gainFinal;
    }
    
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
    if (_mixStruct != undefined) _mixStruct.__Add(__voiceReference);
    
    
    
    
    
    static __Update = function(_delta)
    {
        if (__destroyed) return false;
        
        if (__gainFadeOutSpeed != undefined)
        {
            __gainFadeOut -= _delta*__gainFadeOutSpeed;
            if (__gainFadeOut <= 0)
            {
                __Destroy();
                return false;
            }
            else
            {
                audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
            }
        }
        
        if ((array_length(__soundArray) > 0) && VinylWillStop(__voiceCurrent))
        {
            var _sound = array_pop(__soundArray);
            
            switch(__behaviour)
            {
                case VINYL_QUEUE.PLAY_THROUGH:
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
            __voiceCurrent = audio_play_sound(_sound, 0, _loop, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, 0, __pitchLocal);
            __soundCurrent = _sound;
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
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = max(0, _gain);
        audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = max(0, _gain);
        audio_sound_gain(__voiceCurrent, __VINYL_VOICE_GAIN_EQUATION/VINYL_MAX_VOICE_GAIN, VINYL_STEP_DURATION);
    }
    
    static __SetBehaviour = function(_behaviour, _setForPlaying)
    {
        __behaviour = _behaviour;
        
        if (_setForPlaying)
        {
            switch(_behaviour)
            {
                case VINYL_QUEUE.PLAY_THROUGH:
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
    
    static __Destroy = function()
    {
        __Stop();
        __destroyed = true;
    }
}