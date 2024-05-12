// Feather disable all

/// @oaram behaviour
/// @param loopQueue
/// @param [gain=1]

function VinylQueueCreate(_behaviour, _loopQueue, _gain = 1)
{
    return (new __VinylClassVoiceQueue(_behaviour, _loopQueue, _gain)).__voiceReference;
}