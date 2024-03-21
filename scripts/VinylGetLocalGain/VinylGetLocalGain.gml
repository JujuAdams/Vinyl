// Feather disable all

/// @param voice

function VinylGetLocalGain(_voice)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (_voiceStruct == undefined) _voiceStruct = __VinylVoiceTrack(_voice, audio_sound_get_gain(_voice), audio_sound_get_pitch(_voice), 1, 1);
    return _voiceStruct.__gainLocal;
}