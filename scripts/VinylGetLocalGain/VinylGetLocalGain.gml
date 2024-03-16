// Feather disable all

/// @param voice

function VinylGetLocalGain(_voice)
{
    static _voiceDict = __VinylSystem().__voiceContextDict;
    
    var _voiceContext = struct_get_from_hash(_voiceDict, int64(_voice));
    if (_voiceContext == undefined) _voiceContext = __VinylVoiceTrack(_voice, audio_sound_get_gain(_voice), audio_sound_get_pitch(_voice), 1, 1);
    return _voiceContext.__gainLocal;
}