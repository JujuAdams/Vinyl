/// @param sound
/// @param [loop=false]
/// @param [targetGain=0]
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]
/// @param [pitch=1]

function VinylPlayFadeIn(_sound, _loop = false, _targetGain = 0, _rate = VINYL_DEFAULT_GAIN_RATE, _pitch = 1)
{
    var _id = __VinylDepoolInstance();
    var _instance = global.__vinylIdToInstanceDict[? _id];
    _instance.__Play(_sound, _loop, VINYL_SILENCE, _pitch);
    _instance.__InputGainTargetSet(_targetGain, _rate, false, false);
    return _id;
}