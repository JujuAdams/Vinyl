// Feather disable all

/// @param voice

function VinylHLTEndLoop(_voice)
{
    static _voiceDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceDict, int64(_voice));
    
    var _instanceOf = instanceof(_voiceStruct);
    
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceHLT)) return undefined;
    
    return _voiceStruct.__EndLoop(_voice);
}