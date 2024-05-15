// Feather disable all

/// @param voice

function __VinylEnsureSoundVoice(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        //TODO - Is there a way to derive sound/local/mix gains here?
        
        if (VINYL_LIVE_EDIT)
        {
            __VinylError("Could not find Vinyl voice for ", _voice, "\nPlease report this error");
            return;
        }
        
        _voiceStruct = new __VinylClassVoiceSound(_voice,
                                                  audio_sound_get_loop(_voice),
                                                  audio_sound_get_gain(_voice), 1, 1,
                                                  audio_sound_get_pitch(_voice), 1,
                                                  undefined);
    }
    
    return _voiceStruct;
}