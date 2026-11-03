/// Pauses all sounds currently playing and then resume sounds that are associated with the mix
/// group. This function is relatively slow, especially as your game gets bigger, so use with care.
/// 
/// @param mixGroupIndex

function VinylMixPauseExcept(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        audio_pause_all();
        
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_resume_sound(_soundArray[_i].__sound);
            ++_i;
        }
    }
}