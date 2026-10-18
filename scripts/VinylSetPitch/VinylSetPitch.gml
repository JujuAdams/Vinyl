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
        
        return;
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.__ImplSetPitch(_pitch);
    }
    else
    {
        if (audio_is_playing(_voiceOrArray))
        {
            audio_sound_pitch(_voiceOrArray, _pitch);
        }
    }
}