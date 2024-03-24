// Feather disable all

/// @param voice
/// @param value
/// @param animCurve

function VinylSetBlendAnimCurve(_voice, _value, _animCurve)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return undefined;
    
    return _voiceStruct.__SetBlendAnimCurve(_value, _animCurve);
}