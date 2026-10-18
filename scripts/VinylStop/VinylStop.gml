/// @param voiceOrArray

function VinylStop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylStop(_voiceOrArray[_i]);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.__ImplStop();
    }
    else if (_voiceOrArray != undefined)
    {
        audio_stop_sound(_voiceOrArray);
    }
}