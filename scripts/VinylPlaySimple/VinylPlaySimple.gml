/// Starts playing an untracked soumd and returns a native GameMaker audio instance ID
/// 
/// You cannot use Vinyl functions to later control/manipulate audio playback when using this function
/// This function should only be used for short sound effects such as collecting coins
/// 
/// VinylPlaySimple() cannot be used to play Queue or Multi patterns
/// 
/// @param sound
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlaySimple(_sound, _gain = 1, _pitch = 1)
{
    return __VinylPatternGet(_sound).__PlaySimple(_sound, _gain, _pitch);
}