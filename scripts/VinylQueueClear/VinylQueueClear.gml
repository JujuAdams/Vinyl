// Feather disable all

/// Clears all sounds in a queue voice's array of sounds. This won't stop the currently playing
/// sound, however.
/// 
/// @param voice

function VinylQueueClear(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    array_resize(_voiceStruct.__soundArray, 0);
}