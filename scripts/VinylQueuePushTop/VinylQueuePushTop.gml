// Feather disable all

/// Pushes a sound to the top of a queue's array of sounds. Once the currently playing sound has
/// stopped, the sound pushed by this function will play. If the queue is empty then the next sound
/// will be played at the start of the next frame.
/// 
/// @param voice
/// @param sound

function VinylQueuePushTop(_voice, _sound)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    with(_voiceStruct)
    {
        array_insert(__soundArray, 0, _sound);
        
        if (__behaviour == VINYL_QUEUE.LOOP_ON_LAST)
        {
            audio_sound_loop(__voiceCurrent, (array_length(__soundArray) <= 0));
        }
    }
}