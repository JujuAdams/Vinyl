// Feather disable all

/// Create a new sound queue. This function returns a queue voice which can be used similarly to
/// other Vinyl voices A sound queue is used to play audio in a particular sequence. There are
/// three behaviours that a sound queue can use, found in VINYL_QUEUE enum.
/// 
///   - .DONT_LOOP will play each sound in the queue once
///   - .LOOP_ON_LAST will play each sound in the queue once until the last sound, which is looped
///   - .LOOP_EACH will loop each sound
/// 
/// The currently playing sound can be manually set to loop or not loop by calling VinylSetLoop()
/// targeting the queue voice. If a sound is not looping and completes playing then the next sound
/// in the queue will be played.
/// 
/// The queue itself can be set to loop as well. Internally this is achieved by pushing stopping
/// sounds to the bottom of the queue.
/// 
/// @oaram behaviour
/// @param loopQueue
/// @param [gain=1]

function VinylQueueCreate(_behaviour, _loopQueue, _gain = 1)
{
    return (new __VinylClassVoiceQueue(_behaviour, _loopQueue, _gain)).__voiceReference;
}