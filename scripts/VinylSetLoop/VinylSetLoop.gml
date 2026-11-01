/// Sets a voice to loop or not loop. If an array of voices is provided then this function will set
/// the looping state for all voices in that array. This function can be used to target an HLT
/// brain (`VinylBrainHLT()`) to advance beyond the "loop" playable. Please see that function's
/// documentation for more details.
/// 
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
        return _voiceOrArray.ImplSetLoop(_state);
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            audio_sound_loop(_voiceOrArray, _state);
        }
    }
}