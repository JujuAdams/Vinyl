// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceHLT(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _mixDict                = __VinylSystem().__mixDict;
    static _voiceStructDict        = __VinylSystem().__voiceStructDict;
    static _voiceStructArray       = __VinylSystem().__voiceStructArray;
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    if (VINYL_LIVE_EDIT) array_push(_voiceStructArray, self);
    array_push(_voiceStructUpdateArray, self);
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __gainBase = _pattern.__gain;
    
    if (_pattern.__noMix)
    {
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ _pattern.__mix];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _pattern.__mix, "\" not recognised");
            return;
        }
        
        __gainMix = _mixStruct.__gainFinal;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    __voiceHead = undefined;
    __voiceLoop = undefined;
    __voiceTail = undefined;
    
    var _soundHead = _pattern.__soundHead;
    if (_soundHead != undefined)
    {
        __currentVoice = audio_play_sound(_soundHead, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
        __voiceHead = __currentVoice;
        
        __state = __VINYL_HLT_STATE.__HEAD;
    }
    else
    {
        var _soundLoop = _pattern.__soundLoop;
        if (_soundLoop != undefined)
        {
            __currentVoice = audio_play_sound(_soundLoop, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
            struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
            __voiceLoop = __currentVoice;
            
            __state = __VINYL_HLT_STATE.__LOOP;
        }
        else
        {
            __state = __VINYL_HLT_STATE.__TAIL;
            
            var _soundTail = _pattern.__soundTail;
            if (_soundTail != undefined)
            {
                __currentVoice = audio_play_sound(_soundTail, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
                struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                __voiceLoop = __currentVoice;
            }
            else
            {
                __currentVoice = -1;
            }
        }
    }
    
    __doLoop = true;
    
    
    
    
    
    static __Update = function(_delta)
    {
        if (__gainFadeOutSpeed != undefined)
        {
            __gainFadeOut -= _delta*__gainFadeOutSpeed;
            if (__gainFadeOut <= 0)
            {
                __Stop();
                return false;
            }
            
            audio_sound_gain(__currentVoice, __VINYL_VOICE_GAIN_EQUATION, VINYL_STEP_DURATION);
        }
        
        if (VinylWillStop(__currentVoice))
        {
            switch(__state)
            {
                case __VINYL_HLT_STATE.__HEAD:
                    if (__doLoop && (__pattern.__soundLoop != undefined))
                    {
                        __currentVoice = audio_play_sound(__pattern.__soundLoop, 0, true, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
                        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                        __voiceLoop = __currentVoice;
                        
                        __state = __VINYL_HLT_STATE.__LOOP;
                    }
                    else
                    {
                        __state = __VINYL_HLT_STATE.__TAIL;
                        
                        if (__pattern.__soundTail != undefined)
                        {
                            //If we've already indicated that the loop should end then move on to the tail immediately
                            __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
                            struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                            __voiceTail = __currentVoice;
                        }
                        else
                        {
                            __currentVoice = -1;
                            return false;
                        }
                    }
                break;
                
                case __VINYL_HLT_STATE.__LOOP:
                    __state = __VINYL_HLT_STATE.__TAIL;
                    
                    if (__pattern.__soundTail != undefined)
                    {
                        __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
                        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                        __voiceTail = __currentVoice;
                    }
                    else
                    {
                        __currentVoice = -1;
                        return false;
                    }
                break;
                
                case __VINYL_HLT_STATE.__TAIL:
                    __currentVoice = -1;
                    return false;
                break;
            }
        }
        
        return true;
    }
    
    static __IsPlaying = function()
    {
        return (__currentVoice >= 0);
    }
    
    static __Stop = function()
    {
        if (__currentVoice >= 0)
        {
            audio_stop_sound(__currentVoice);
            __state = __VINYL_HLT_STATE.__TAIL;
        }
    }
    
    static __Pause = function()
    {
        audio_pause_sound(__currentVoice);
    }
    
    static __Resume = function()
    {
        audio_resume_sound(__currentVoice);
    }
    
    static __IsPaused = function()
    {
        return audio_is_paused(__currentVoice);
    }
    
    static __FadeOut = function(_rateOfChange)
    {
        __gainFadeOutSpeed = max(0.001, _rateOfChange);
    }
    
    static __SetLocalGain = function(_gain)
    {
        __gainLocal = _gain;
        audio_sound_gain(__currentVoice, __VINYL_VOICE_GAIN_EQUATION, VINYL_STEP_DURATION);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = _gain;
        audio_sound_gain(__currentVoice, __VINYL_VOICE_GAIN_EQUATION, VINYL_STEP_DURATION);
    }
    
    static __EndLoop = function()
    {
        __doLoop = false;
        if (__state == __VINYL_HLT_STATE.__LOOP) audio_sound_loop(__currentVoice, false);
    }
}