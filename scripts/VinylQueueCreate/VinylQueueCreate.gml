// Feather disable all

/// @oaram behaviour
/// @param loopQueue
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylQueueCreate(_behaviour, _loopQueue, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    var _queue = new __VinylClassVoiceQueue(_behaviour, _loopQueue, _gain, _mix);
    return _queue.__voiceReference;
}