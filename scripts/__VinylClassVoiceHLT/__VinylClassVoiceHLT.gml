// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceHLT(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _mixDict           = __VinylSystem().__mixDict;
    static _voiceStructDict   = __VinylSystem().__voiceStructDict;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    array_push(_voiceUpdateArray, self);
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __gainBase = _pattern.__gain;
    
    if (_pattern.__noMix)
    {
        var _mixStruct = undefined;
        __gainMix = 1;
    }
    else
    {
        var _mixStruct = _mixDict[$ _pattern.__mixName];
        if (_mixStruct == undefined)
        {
            __VinylError("Mix \"", _pattern.__mixName, "\" not recognised");
            return;
        }
        
        __gainMix = _mixStruct.__gainFinal;
    }
    
    __gainFadeOut      = 1;
    __gainFadeOutSpeed = undefined;
    
    //Manage which sound to play to begin with
    var _soundHead = _pattern.__soundHead;
    if (_soundHead != undefined)
    {
        __currentVoice = audio_play_sound(_soundHead, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
        __state = __VINYL_HLT_STATE.__HEAD;
    }
    else
    {
        var _soundLoop = _pattern.__soundLoop;
        if (_soundLoop != undefined)
        {
            __currentVoice = audio_play_sound(_soundLoop, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
            __state = __VINYL_HLT_STATE.__LOOP;
        }
        else
        {
            var _soundTail = _pattern.__soundTail;
            __currentVoice = (_soundTail == undefined)? -1 : audio_play_sound(_soundTail, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
            __state = __VINYL_HLT_STATE.__TAIL;
        }
    }
    
    __firstVoice = __currentVoice;
    
    //Add the generated voice to the mix's array of voices
    if (__firstVoice >= 0)
    {
        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
        if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Adding ", __currentVoice, " to voice lookup struct");
        if (_mixStruct == undefined) _mixStruct.__Add(__firstVoice);
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
                        
                        //Add the generated voice to the mix's array of voices
                        var _mixStruct = _mixDict[$ __pattern.__mixName];
                        if (_mixStruct == undefined) _mixStruct.__Add(__currentVoice);
                        
                        __state = __VINYL_HLT_STATE.__LOOP;
                    }
                    else
                    {
                        __state = __VINYL_HLT_STATE.__TAIL;
                        
                        if (__pattern.__soundTail != undefined)
                        {
                            //If we've already indicated that the loop should end then move on to the tail immediately
                            __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false, __VINYL_VOICE_GAIN_EQUATION, 0, __pitchLocal);
                            
                            //Add the generated voice to the mix's array of voices
                            var _mixStruct = _mixDict[$ __pattern.__mixName];
                            if (_mixStruct == undefined) _mixStruct.__Add(__currentVoice);
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
                        
                        //Add the generated voice to the mix's array of voices
                        var _mixStruct = _mixDict[$ __pattern.__mixName];
                        if (_mixStruct == undefined) _mixStruct.__Add(__currentVoice);
                    }
                    else
                    {
                        __currentVoice = -1;
                        return false;
                    }
                break;
                
                case __VINYL_HLT_STATE.__TAIL:
                    __currentVoice = -1;
                    
                    //FIXME - Replace with struct_remove_from_hash() when that is made available
                    struct_set_from_hash(_voiceStructDict, int64(__firstVoice), undefined);
                    if (VINYL_DEBUG_LEVEL >= 2) __VinylTrace("Removing ", __firstVoice, " from voice lookup struct");
                    
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
        __gainLocal = max(0, _gain);
        audio_sound_gain(__currentVoice, __VINYL_VOICE_GAIN_EQUATION, VINYL_STEP_DURATION);
    }
    
    static __SetMixGain = function(_gain)
    {
        __gainMix = max(0, _gain);
        audio_sound_gain(__currentVoice, __VINYL_VOICE_GAIN_EQUATION, VINYL_STEP_DURATION);
    }
    
    static __EndLoop = function()
    {
        __doLoop = false;
        if (__state == __VINYL_HLT_STATE.__LOOP) audio_sound_loop(__currentVoice, false);
    }
}