/// Starts playing an untracked soumd and returns a native GameMaker audio instance ID
/// 
/// You cannot use Vinyl functions to later control/manipulate audio playback when using this function
/// This function should only be used for short sound effects such as collecting coins
/// 
/// @param sound
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlaySimple(_sound, _gain = 1, _pitch = 1)
{
    return __VinylPatternGet(_sound).__PlaySimple(_gain, _pitch, _sound);
}