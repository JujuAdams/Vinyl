// Feather disable all

/// Sets the local gain for a sound being played on a blend voice. This gain value is relative to
/// the gain for the blend voice as a whole, any mix gain etc.
/// 
/// @param voice
/// @param index
/// @param gain

function VinylSetBlendMemberGain(_voice, _index, _gain)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__SetMemberGain(_index, _gain);
}