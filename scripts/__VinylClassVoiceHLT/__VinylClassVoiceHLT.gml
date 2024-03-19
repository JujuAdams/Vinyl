// Feather disable all

/// @param pattern

function __VinylClassVoiceHLT(_pattern) constructor
{
    static _voiceStructArray       = __VinylSystem().__voiceStructArray;
    static _voiceStructDict        = __VinylSystem().__voiceStructDict;
    static _voiceStructUpdateArray = __VinylSystem().__voiceStructUpdateArray;
    
    array_push(_voiceStructArray, self);
    array_push(_voiceStructUpdateArray, self);
    
    __pattern = _pattern;
    
    __voiceHead = undefined;
    __voiceLoop = undefined;
    __voiceTail = undefined;
    
    var _soundHead = __pattern.__soundHead;
    if (_soundHead != undefined)
    {
        __currentVoice = audio_play_sound(_soundHead, 0, false);
        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
        __voiceHead = __currentVoice;
        
        __state = __VINYL_HLT_STATE.__HEAD;
    }
    else
    {
        __currentVoice = audio_play_sound(__pattern.__soundLoop, 0, false);
        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
        __voiceLoop = __currentVoice;
        
        __state = __VINYL_HLT_STATE.__LOOP;
    }
    
    __doLoop = true;
    
    
    
    
    
    static __Update = function()
    {
        if (VinylWillStop(__currentVoice))
        {
            switch(__state)
            {
                case __VINYL_HLT_STATE.__HEAD:
                    if (__doLoop)
                    {
                        __currentVoice = audio_play_sound(__pattern.__soundLoop, 0, true);
                        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                        __voiceLoop = __currentVoice;
                        
                        __state = __VINYL_HLT_STATE.__LOOP;
                    }
                    else
                    {
                        //If we've already indicated that the loop should end then move on to the tail immediately
                        __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false);
                        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                        __voiceTail = __currentVoice;
                        
                        __state = __VINYL_HLT_STATE.__TAIL;
                    }
                break;
                
                case __VINYL_HLT_STATE.__LOOP:
                    __state = __VINYL_HLT_STATE.__TAIL;
                    
                    if (__pattern.__soundTail != undefined)
                    {
                        __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false);
                        struct_set_from_hash(_voiceStructDict, int64(__currentVoice), self);
                        __voiceTail = __currentVoice;
                    }
                    else
                    {
                        __currentVoice = undefined;
                        return false;
                    }
                break;
                
                case __VINYL_HLT_STATE.__TAIL:
                    __currentVoice = undefined;
                    return false;
                break;
            }
        }
        
        return true;
    }
    
    static __IsPlaying = function()
    {
        return (__currentVoice != undefined);
    }
    
    static __EndLoop = function()
    {
        __doLoop = false;
        if (__state == __VINYL_HLT_STATE.__LOOP) audio_sound_loop(__currentVoice, false);
    }
}