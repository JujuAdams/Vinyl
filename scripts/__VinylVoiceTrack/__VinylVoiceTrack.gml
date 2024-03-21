// Feather disable all

/// @param voice
/// @param gainLocal
/// @param pitchLocal
/// @param gainPattern
/// @param pitchPattern

function __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern)
{
    static _voiceStructDict  = __VinylSystem().__voiceStructDict;
    static _voiceArray = __VinylSystem().__voiceStructArray;
    
    var _struct = new __VinylClassVoiceSound(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern);
    array_push(_voiceArray, _struct);
    struct_set_from_hash(_voiceStructDict, int64(_voice), _struct);
    
    return _struct;
}