// Feather disable all

/// @param voice

function VinylHLTEndLoop(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceHLT)) return undefined;
    
    return _voiceStruct.__EndLoop(_voice);
}