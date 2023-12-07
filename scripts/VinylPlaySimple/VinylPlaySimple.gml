// Feather disable all
/// Starts playing an untracked soumd and returns a native GameMaker voice ID
/// This function is a more performant way to play short audio clips
/// 
/// You cannot use Vinyl functions to later control/manipulate audio playback when using this function
/// This function should only be used for short sound effects such as collecting coins
/// 
/// VinylPlaySimple() cannot be used to play Queue or Multi patterns, and simple audio will not be
/// set to loop by Vinyl regardless of configuration settings
/// 
/// @param sound
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlaySimple(_sound, _gain = 1, _pitch = 1)
{
    static _checkForRemapping = __VinylGetLiveUpdateEnabled();
    if (_checkForRemapping && is_numeric(_sound))
    {
        var _inSound = _sound;
        var _soundName = audio_get_name(_sound);
        _sound = VinylAssetGetIndex(_soundName);
        
        if (_sound < 0)
        {
            __VinylTrace("Warning! Sound \"", _soundName, "\" (", _inSound, ") does not have an updated asset");
        }
    }
    
    static _labelArray = [];
    var _result = __VinylPatternGet(_sound).__PlaySimple(_sound, _gain, _gain, _pitch, _pitch, _labelArray, undefined);
    array_resize(_labelArray, 0);
    
    return _result;
}
