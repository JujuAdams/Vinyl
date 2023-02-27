/// Fades out all Vinyl playback instances, stopping them once they reach silence
// 
/// Once a playback instance is fading out, the process cannot be halted or paused
/// This is called "shutdown" mode, and you can detect if a Vinyl instance is fading
/// out by calling VinylShutdownGet()
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylFadeOutAll(_rate = VINYL_DEFAULT_GAIN_RATE)
{
    static _topLevelArray = __VinylGlobalData().__topLevelArray;
    
    var _i = 0;
    repeat(array_length(_topLevelArray))
    {
        _topLevelArray[_i].__FadeOut(_rate);
        ++_i;
    }
}