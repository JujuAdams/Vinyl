// Feather disable all

/// Sets whether the queue voice itself should loop. If you'd like to alter the loop state of
/// the currently playing sound then use VinylGetLoop().
/// 
/// @param voice
/// @param state

function VinylQueueSetLoop(_voice, _state)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    _voiceStruct.__loopQueue = _state;
}