/// Starts playing a sound by fading it in, and returns a Vinyl ID to identify the playback instance
/// 
/// @param sound
/// @param [loop]
/// @param [targetGain=1]
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylPlayFadeIn(_sound, _loop = undefined, _targetGain = 1, _rate = VINYL_DEFAULT_GAIN_RATE)
{
    var _id = VinylPlay(_sound, _loop, 0);
    VinylGainTargetSet(_id, _targetGain, _rate);
    return _id;
}