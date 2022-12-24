/// Starts playing a sound by fading it in, and returns a Vinyl ID to identify the playback instance
/// 
/// @param sound
/// @param [loop]
/// @param [targetGain=0dB]
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]
/// @param [pitch=100%]

function VinylPlayFadeIn(_sound, _loop = undefined, _targetGain = 0, _rate = VINYL_DEFAULT_GAIN_RATE, _pitch = 100)
{
    var _id = __VinylDepoolInstance();
    var _instance = global.__vinylIdToInstanceDict[? _id];
    _instance.__Play(_sound, _loop, VINYL_SILENCE, _pitch);
    _instance.__InputGainTargetSet(_targetGain, _rate, false);
    return _id;
}