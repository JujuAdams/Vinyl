/// Starts playing an untracked soumd and returns a native GameMaker audio instance ID
/// 
/// You cannot use Vinyl functions to later control/manipulate audio playback when using this function
/// This function should only be used for short sound effects such as collecting coins
/// 
/// @param sound
/// @param [gain]
/// @param [pitch]

function VinylPlaySimple(_sound, _gain = (VINYL_GAIN_DECIBEL_MODE? 0 : 1), _pitch = (VINYL_PITCH_PERCENTAGE_MODE? 100 : 1))
{
    if (VINYL_GAIN_DECIBEL_MODE) _gain = __VinylGainToAmplitude(_gain);
    if (VINYL_PITCH_PERCENTAGE_MODE) _pitch /= 100;
    
    return __VinylPatternGet(_sound).__PlaySimple(_gain, _pitch, _sound);
}