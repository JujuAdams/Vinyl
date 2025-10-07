// Feather disable all

/// Clears all sounds in a queue's array of sounds. If the optional parameter `stopCurrent` is set
/// to `true` then the currently playing sound will be stopped as well. However, by default, this
/// isn't the case and the currently playing sound for the queue will continue to play.
/// 
/// @param voice
/// @param [stopCurrent=false]

function VinylQueueClear(_voice, _stopCurrent = false)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    if (_stopCurrent)
    {
        VinylStop(_voice);
    }
    
    array_resize(_voiceStruct.__soundArray, 0);
}