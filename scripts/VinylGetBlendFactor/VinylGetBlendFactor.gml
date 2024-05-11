// Feather disable all

/// Returns the blend factor for a blend voice. If the target voice is not a blend voice then this
/// function will return <undefined>.
/// 
/// @param voice

function VinylGetBlendFactor(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__blendFactor;
}