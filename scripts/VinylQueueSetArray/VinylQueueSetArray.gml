// Feather disable all

/// @param voice
/// @param soundArray

function VinylQueueSetArray(_voice, _soundArray)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    _voiceStruct.__soundArray = _soundArray;
}