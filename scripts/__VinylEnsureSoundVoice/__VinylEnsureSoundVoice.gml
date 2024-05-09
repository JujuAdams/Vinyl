// Feather disable all

/// @param voice

function __VinylEnsureSoundVoice(_voice)
{
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    
    if (_voiceStruct == undefined)
    {
        return __VinylCreateSoundVoice(_voice,
                                       1, audio_sound_get_gain(_voice), 1,
                                       1, audio_sound_get_pitch(_voice),
                                       undefined, 0.5, 0.5);
    }
    
    return _voiceStruct;
}