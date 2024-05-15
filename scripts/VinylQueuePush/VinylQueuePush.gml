// Feather disable all

/// Pushes a sound to a queue voice's array of voices. If the queue is empty then the sound will
/// be played at the start of the next frame.
/// 
/// @param voice
/// @param sound

function VinylQueuePush(_voice, _sound)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    array_push(_voiceStruct.__soundArray, _sound);
}