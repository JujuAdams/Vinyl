/// @param voiceOrArray

function VinylGetTrackPosition(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (VinylGetAnyPlaying(_voiceOrArray))
            {
                return VinylGetTrackPosition(_voiceOrArray[0]);
            }
            
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.ImplGetTrackPosition();
    }
    else if (_voiceOrArray != undefined)
    {
        return audio_sound_get_track_position(_voiceOrArray);
    }
    
    return 0;
}