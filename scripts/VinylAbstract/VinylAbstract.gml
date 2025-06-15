// Feather disable all

/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]
/// @param [duckerName]
/// @param [duckPriority]
/// @param [mixName]

function VinylAbstract(_loopLocal, _gainLocal = 1, _pitchLocal = 1, _duckerNameLocal = undefined, _duckPrioLocal = undefined, _mixName = undefined)
{
    return (new __VinylClassVoiceAbstract(undefined, _loopLocal, _gainLocal, _pitchLocal, _duckerNameLocal, _duckPrioLocal, _mixName)).__voiceReference;
}