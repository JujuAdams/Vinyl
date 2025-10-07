// Feather disable all

/// Sets the queue of sounds for a queue created by VinylQueueCreate(). This function will "save" a
/// copy of the input array which means that any adjustment to the input array after calling
/// VinylQueueSetArray() will not alter what sounds are played back. You will need to call
/// VinylQueueSetArray() again if you want to change the internal sound array.
/// 
/// @param voice
/// @param soundArray

function VinylQueueSetArray(_voice, _soundArray)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    with(_voiceStruct)
    {
        __soundArray = variable_clone(_soundArray);
        
        if (__behaviour == VINYL_QUEUE.LOOP_ON_LAST)
        {
            audio_sound_loop(__voiceCurrent, (array_length(__soundArray) <= 0));
        }
    }
}