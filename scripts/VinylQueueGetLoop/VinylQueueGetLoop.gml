// Feather disable all

/// Returns whether the queue itself is set to loop. If you'd like to return the loop state of the
/// currently playing sound then use VinylGetLoop().
/// 
/// @param voice

function VinylQueueGetLoop(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__loopQueue;
}