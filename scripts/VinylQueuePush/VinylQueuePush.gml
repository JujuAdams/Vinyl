// Feather disable all

/// @param voice
/// @param sound

function VinylQueuePush(_voice, _sound)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    array_push(_voiceStruct.__soundArray, _sound);
}