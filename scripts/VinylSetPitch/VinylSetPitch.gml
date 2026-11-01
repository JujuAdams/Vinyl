/// Sets the pitch for a voice. If an array is provided then the pitch will be set for every voice
/// equally.
/// 
/// @param voiceOrArray
/// @param pitch

function VinylSetPitch(_voiceOrArray, _pitch)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylSetPitch(_voiceOrArray[_i], _pitch);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.ImplSetPitch(_pitch);
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            audio_sound_pitch(_voiceOrArray, _pitch);
        }
    }
}