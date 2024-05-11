// Feather disable all

/// Indicates to a head-loop-tail voice that you'd like the loop segment to stop playing soon and
/// for playback to move onto the tail voice. If the target voice is not a head-loop-tail voice
/// then this function does nothing.
/// 
/// @param voice

function VinylHLTEndLoop(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceHLT)) return undefined;
    
    return _voiceStruct.__EndLoop(_voice);
}