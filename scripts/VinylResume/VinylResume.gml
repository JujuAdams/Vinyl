/// @param voiceOrArray

function VinylResume(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylResume(_voiceOrArray[_i]);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.__ImplResume();
    }
    else
    {
        audio_resume_sound(_voiceOrArray);
    }
}