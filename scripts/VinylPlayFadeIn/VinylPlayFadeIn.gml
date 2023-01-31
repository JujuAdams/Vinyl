/// Starts playing a sound by fading it in, and returns a Vinyl ID to identify the playback instance
/// 
/// @param sound
/// @param [loop]
/// @param [targetGain]
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]
/// @param [pitch]

function VinylPlayFadeIn(_sound, _loop = undefined, _targetGain = (VINYL_GAIN_DECIBEL_MODE? 0 : 1), _rate = VINYL_DEFAULT_GAIN_RATE, _pitch = (VINYL_PITCH_PERCENTAGE_MODE? 100 : 1))
{
    if (VINYL_GAIN_DECIBEL_MODE) _targetGain = __VinylGainToAmplitude(_targetGain);
    if (VINYL_PITCH_PERCENTAGE_MODE) _pitch /= 100;
    
    var _id = __VinylDepoolInstance();
    var _instance = global.__vinylIdToInstanceDict[? _id];
    _instance.__Play(_sound, _loop, (VINYL_GAIN_DECIBEL_MODE? 0 : 1), _pitch);
    _instance.__InputGainTargetSet(_targetGain, _rate);
    return _id;
}