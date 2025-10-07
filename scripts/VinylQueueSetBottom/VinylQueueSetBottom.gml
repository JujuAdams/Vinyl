// Feather disable all

/// Sets the bottom sound of a queue to a particular sound. This will replace any sound that's
/// currently on the bottom of the queue's sound array.
/// 
/// @param voice
/// @param sound

function VinylQueueSetBottom(_voice, _sound)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    with(_voiceStruct)
    {
        __soundArray[@ max(0, array_length(__soundArray)-1)] = _sound;
        
        if (__behaviour == VINYL_QUEUE.LOOP_ON_LAST)
        {
            audio_sound_loop(__voiceCurrent, (array_length(__soundArray) <= 0));
        }
    }
}