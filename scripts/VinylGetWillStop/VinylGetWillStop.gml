/// Returns `true` if the voice will stop before the next frame. This check is approximate and may
/// sometimes be wrong. If an array is passed, this function will return `true` if *all* voices in
/// the given array are likely to stop in the next step (or have already stopped). If an empty
/// array is provided then this function will always return `true`.
/// 
/// @param voiceOrArray

function VinylGetWillStop(_voiceOrArray)
{
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            if (not VinylGetWillStop(_voiceOrArray[_i]))
            {
                return false;
            }
            
            ++_i;
        }
        
        return true;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetWillStop();
    }
    else if (_voiceOrArray != undefined)
    {
        var _voice = _voiceOrArray;
        
        if (not audio_is_playing(_voice)) return true;
        if (audio_sound_get_loop(_voice)) return false;
        if (audio_is_paused(_voice)) return false;
        
        if (audio_sound_get_loop_end(_voice) <= 0)
        {
            //No loop points
            return (audio_sound_get_track_position(_voice) >= audio_sound_length(_voice) - audio_sound_get_pitch(_voice)*VINYL_WILL_STOP_TOLERANCE/1000);
        }
        else
        {
            return (audio_sound_get_track_position(_voice) >= audio_sound_get_loop_end(_voice) - audio_sound_get_pitch(_voice)*VINYL_WILL_STOP_TOLERANCE/1000);
        }
    }
    
    return true;
}