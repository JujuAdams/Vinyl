// Feather disable all

/// @param pattern
/// @param gainLocal
/// @param pitchLocal

function __VinylClassVoiceHLT(_pattern, _gainLocal, _pitchLocal) constructor
{
    static _voiceStructArray       = __VinylSystem().__voiceStructArray;
    static _voiceStructDict        = __VinylSystem().__voiceStructDict;
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    array_push(_voiceStructArray, self);
    array_push(_voiceStructUpdateArray, self);
    
    __pattern    = _pattern;
    __gainLocal  = _gainLocal;
    __pitchLocal = _pitchLocal;
    
    __voiceHead = undefined;
    __voiceLoop = undefined;
    __voiceTail = undefined;
    
    var _soundHead = __pattern.__soundHead;
    if (_soundHead != undefined)
    {
        __currentVoice = audio_play_sound(_soundHead, 0, false, __pattern.__gain*__gainLocal, 0, __pitchLocal);
        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
        __voiceHead = __currentVoice;
        
        __state = __VINYL_HLT_STATE.__HEAD;
    }
    else
    {
        var _soundLoop = __pattern.__soundLoop;
        if (_soundLoop != undefined)
        {
            __currentVoice = audio_play_sound(_soundLoop, 0, false, __pattern.__gain*__gainLocal, 0, __pitchLocal);
            struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
            __voiceLoop = __currentVoice;
            
            __state = __VINYL_HLT_STATE.__LOOP;
        }
        else
        {
            __state = __VINYL_HLT_STATE.__TAIL;
            
            var _soundTail = __pattern.__soundTail;
            if (_soundTail != undefined)
            {
                __currentVoice = audio_play_sound(_soundTail, 0, false, __pattern.__gain*__gainLocal, 0, __pitchLocal);
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
    
    
    
    
    
    static __Update = function()
    {
        if (VinylWillStop(__currentVoice))
        {
            switch(__state)
            {
                case __VINYL_HLT_STATE.__HEAD:
                    if (__doLoop && (__pattern.__soundLoop != undefined))
                    {
                        __currentVoice = audio_play_sound(__pattern.__soundLoop, 0, true, __pattern.__gain*__gainLocal, 0, __pitchLocal);
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
                            __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false, __pattern.__gain*__gainLocal, 0, __pitchLocal);
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
                        __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false, __pattern.__gain*__gainLocal, 0, __pitchLocal);
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
    
    static __EndLoop = function()
    {
        __doLoop = false;
        if (__state == __VINYL_HLT_STATE.__LOOP) audio_sound_loop(__currentVoice, false);
    }
}