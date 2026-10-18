/// @param voiceOrArray
/// @param state

function VinylSetLoop(_voiceOrArray, _state)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylSetLoop(_voiceOrArray[_i], _state);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.__ImplSetLoop(_state);
    }
    else
    {
        audio_sound_loop(_voiceOrArray, _state);
    }
}