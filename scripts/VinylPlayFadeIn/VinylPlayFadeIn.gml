// Feather disable all

/// Convenience function to play a new sound or pattern and fade it in. Please see VinylPlay() for
/// more information.
/// 
/// @param sound/pattern
/// @param [loop]
/// @param [targetGain=1]
/// @oaram [rateOfChange]
/// @param [pitch=1]

function VinylPlayFadeIn(_pattern, _loop = undefined, _gain = 1, _rateOfChange = infinity, _pitch = 1)
{
    var _voice = VinylPlay(_pattern, _loop, 0, _pitch);
    VinylSetGain(_voice, _gain, _rateOfChange);
    return _voice;
}