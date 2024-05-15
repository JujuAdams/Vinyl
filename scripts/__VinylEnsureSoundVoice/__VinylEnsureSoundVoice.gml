// Feather disable all

/// @param voice

function __VinylEnsureSoundVoice(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        //TODO - Is there a way to derive sound/local/mix gains here?
        _voiceStruct = new __VinylClassVoiceSound(_voice,
                                                  audio_sound_get_loop(_voice),
                                                  1, audio_sound_get_gain(_voice), 1,
                                                  1, audio_sound_get_pitch(_voice),
                                                  undefined);
    }
    
    return _voiceStruct;
}