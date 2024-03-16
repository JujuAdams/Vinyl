// Feather disable all

/// @param voice
/// @param gainLocal
/// @param gainFinal
/// @param pitchLocal
/// @param pitchFinal

function __VinylVoiceTrack(_voice, _gainLocal, _gainFinal, _pitchLocal, _pitchFinal)
{
    static _voiceDict  = __VinylSystem().__voiceContextDict;
    static _voiceArray = __VinylSystem().__voiceContextArray;
    
    var _struct = new __VinylClassVoiceContext(_voice, _gainLocal, _gainFinal, _pitchLocal, _pitchFinal);
    array_push(_voiceArray, _struct);
    struct_set_from_hash(_voiceDict, int64(_voice), _struct);
    
    return _struct;
}