// Feather disable all

/// @param voice
/// @param value

function VinylSetBlendFactor(_voice, _value)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__SetBlend(_value);
}