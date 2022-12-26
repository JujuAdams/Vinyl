/// Starts playing an untracked soumd and returns a native GameMaker audio instance ID
/// You cannot use Vinyl functions to later control/manipulate audio playback when using this function
/// This function should only be used for short, oft-played sound effects
/// 
/// @param sound
/// @param [gain=0dB]
/// @param [pitch=100%]

function VinylPlaySimple(_sound, _gain = 0, _pitch = 100)
{
    return __VinylAssetGet(_sound).__PlaySimple(_gain, _pitch, _sound);
}