// Feather disable all

function __VinylClassVoiceHLT()
{
    __pattern      = undefined;
    __currentVoice = undefined;
    
    __state  = 0; //0 = head, 1 = loop, 2 = tail
    __doLoop = true;
    
    static __Update = function()
    {
        if (not audio_is_playing(__currentVoice))
        {
            if (__state == 0)
            {
                if (__doLoop)
                {
                    __currentVoice = audio_play_sound(__pattern.__soundLoop, 0, true);
                    __state = 1;
                }
                else
                {
                    __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false);
                    __state = 2;
                }
            }
            else if (__state == 1)
            {
                __currentVoice = audio_play_sound(__pattern.__soundTail, 0, false);
                __state = 2;
            }
        }
    }
    
    static __Cue = function()
    {
        __doLoop = false;
        if (__state == 1) audio_sound_loop(__currentVoice, false);
    }
}