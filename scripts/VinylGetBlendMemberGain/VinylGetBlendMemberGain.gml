// Feather disable all

/// Returns the local gain for a sound being played on a blend voice. The returned value will not
/// take into account the gain of the blend voice, any mix gain etc. If an invalid index is
/// accessed (less than 0, more than the total number of sounds) then this function returns 0.
/// 
/// @param voice
/// @param index

function VinylGetBlendMemberGain(_voice, _index)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__GetMemberGain(_index);
}