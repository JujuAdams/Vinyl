// Feather disable all

/// Sets the bottom sound of a queue to a particular sound. This will replace any sound that's
/// currently on the bottom of the queue's sound array.
/// 
/// @param voice
/// @param sound

function VinylQueuePushBottom(_voice, _sound)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    var _array = _voiceStruct.__soundArray;
    _array[max(0, array_length(_array)-1)] = _sound;
}