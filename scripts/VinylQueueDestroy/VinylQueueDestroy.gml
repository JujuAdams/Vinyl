// Feather disable all

/// Destroys a queue voice. This stops any currently playing audio and renders the queue voice
/// inoperable. This function is provided for convenience and You don't have to call this function
/// to manage memory.
/// 
/// @param voice

function VinylQueueDestroy(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__Destroy();
}