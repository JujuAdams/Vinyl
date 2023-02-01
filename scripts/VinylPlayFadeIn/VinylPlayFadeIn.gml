/// Starts playing a sound by fading it in, and returns a Vinyl ID to identify the playback instance
/// 
/// @param sound
/// @param [loop]
/// @param [targetGain=1]
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]
/// @param [pitch=1]

function VinylPlayFadeIn(_sound, _loop = undefined, _targetGain = 1, _rate = VINYL_DEFAULT_GAIN_RATE, _pitch = 1)
{
    var _id = __VinylDepoolInstance();
    var _instance = global.__vinylIdToInstanceDict[? _id];
    _instance.__Play(_sound, _loop, 0, _pitch);
    _instance.__InputGainTargetSet(_targetGain, _rate);
    return _id;
}