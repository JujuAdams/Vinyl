/// @param mixGroupIndex

function VinylMixGroupPauseExcept(_mixGroupIndex)
{
    with(__VinylGetMixGroup(_mixGroupIndex))
    {
        audio_pause_all();
        
        var _soundArray = __soundArray;
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            audio_resume_sound(_soundArray[_i]);
            ++_i;
        }
    }
}