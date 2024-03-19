// Feather disable all

/// @param voice

function VinylHeadLoopTailCue(_voice)
{
    static _voiceDict = __VinylSystem().__voiceContextDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceHLT)) return undefined;
    
    return _voiceStruct.__Cue(_voice);
}