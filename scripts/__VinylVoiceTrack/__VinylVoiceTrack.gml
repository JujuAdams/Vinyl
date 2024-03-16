// Feather disable all

/// @param voice
/// @param gainMultiplier
/// @param gainFinal
/// @param pitchMultiplier
/// @param pitchFinal

function __VinylVoiceTrack(_voice, _gainMultiplier, _gainFinal, _pitchMultiplier, _pitchFinal)
{
    static _voiceDict  = __VinylSystem().__voiceDict;
    static _voiceArray = __VinylSystem().__voiceArray;
    
    var _struct = {
        __voice:           _voice,
        __gainMultiplier:  _gainMultiplier,
        __gainFinal:       _gainFinal,
        __pitchMultiplier: _pitchMultiplier,
        __pitchFinal:      _pitchFinal,
    };
    
    array_push(_voiceArray, _struct);
    struct_set_from_hash(_voiceDict, int64(_voice), _struct);
    
    return _struct;
}