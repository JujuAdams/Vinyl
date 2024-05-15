// Feather disable all

/// Returns the blend factor for a blend voice. If the target voice is not a blend voice then this
/// function will return <undefined>.
/// 
/// @param voice

function VinylGetBlendFactor(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__blendFactor;
}