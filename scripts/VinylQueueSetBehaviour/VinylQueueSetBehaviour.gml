// Feather disable all

/// @param voice
/// @param behaviour
/// @param [setForPlaying=true]

function VinylQueueSetBehaviour(_voice, _behaviour, _setForPlaying = true)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__SetBehaviour(_behaviour, _setForPlaying);
}