// Feather disable all

/// @param voice
/// @param gainBase
/// @param gainLocal
/// @param gainMix
/// @param pitchBase
/// @param pitchLocal
/// @param [pattern]
/// @param [gainFactor]
/// @param [pitchFactor]

function __VinylCreateSoundVoice(_voice, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, _pattern, _gainFactor, _pitchFactor)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    static _voiceArray      = __VinylSystem().__voiceStructArray;
    
    var _struct = new __VinylClassVoiceSound(_voice, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, _pattern, _gainFactor, _pitchFactor);
    array_push(_voiceArray, _struct);
    struct_set_from_hash(_voiceStructDict, int64(_voice), _struct);
    
    return _struct;
}