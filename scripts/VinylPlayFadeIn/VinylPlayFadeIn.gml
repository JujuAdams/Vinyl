// Feather disable all

/// Convenience function to play a new sound or pattern and fade it in. Please see VinylPlay() for
/// more information.
/// 
/// @param sound/pattern
/// @param [loop]
/// @param [targetGain=1]
/// @oaram [rateOfChange]
/// @param [pitch=1]
/// @param [duck]
/// @param [duckPrio]

function VinylPlayFadeIn(_pattern, _loop = undefined, _gain = 1, _rateOfChange = infinity, _pitch = 1, _duckName = undefined, _duckPrio = undefined)
{
    var _voice = VinylPlay(_pattern, _loop, 0, _pitch, _duckName, _duckPrio);
    VinylSetGain(_voice, _gain, _rateOfChange);
    return _voice;
}