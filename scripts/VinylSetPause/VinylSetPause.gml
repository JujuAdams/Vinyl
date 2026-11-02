/// Sets a voice to pause (state is `true`) or resume (state is `false`). If an array of voices is
/// provided then this function will set the pause state for all voices in that array.
/// 
/// @param voiceOrArray
/// @param state

function VinylSetPause(_voiceOrArray, _state)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylSetPause(_voiceOrArray[_i], _state);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.ImplSetPause(_state);
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            if (_state)
            {
                audio_pause_sound(_voiceOrArray);
            }
            else
            {
                audio_resume_sound(_voiceOrArray);
            }
        }
    }
}