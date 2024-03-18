// Feather disable all

/// @param sound/pattern
/// @param [loop]
/// @param [gain=1]
/// @param [loop=1]

function VinylPlay(_pattern, _loop = undefined, _gain = 1, _pitch = 1)
{
    static _genPlayData = __VinylGenPlay();
    static _voiceContextDict = __VinylSystem().__voiceContextDict;
    
    var _function = struct_get_from_hash(_genPlayData, int64(_pattern));
    if (_function == undefined)
    {
        //Passing in a number that's too big will fool audio_exists()
        //Our patterns occupy numbers that use the upper 32 bits of an int64
        //Checking if the number fits into the first 32 bits is sufficient to work around this bug
        if ((int64(_pattern) <= 0xFFFFFFFF) && audio_exists(_pattern))
        {
            var _voice = audio_play_sound(_pattern, 0, _loop ?? false, _gain, 0, _pitch);
            
            if (__VINYL_REPORT_FAILURE_TO_PLAY && (_voice < 0))
            {
                __VinylWarning("Failed to play sound ", audio_get_name(_pattern));
                return _voice;
            }
            
            if (VINYL_LIVE_EDIT) __VinylVoiceTrack(_voice, _gain, _pitch, 1, 1).__pattern = _pattern;
            return _voice;
        }
        else
        {
            if (__VINYL_RUNNING_FROM_IDE)
            {
                __VinylWarning("Could not find data for pattern ", ptr(_pattern));
                
                var _voice = audio_play_sound(VinylFallbackSound, 0, false, _gain, 0, _pitch);
                if (__VINYL_REPORT_FAILURE_TO_PLAY && (_voice < 0))
                {
                    __VinylWarning("Failed to play sound ", audio_get_name(VinylFallbackSound));
                    return _voice;
                }
                
                if (VINYL_LIVE_EDIT) __VinylVoiceTrack(_voice, _gain, _pitch, 1, 1).__pattern = _pattern;
                return _voice;
            }
            else
            {
                return -1;
            }
        }
    }
    else
    {
        if (__VINYL_REPORT_FAILURE_TO_PLAY)
        {
            var _voice = _function(_loop, _gain, _pitch);
            if (_voice < 0) __VinylWarning("Failed to play sound ", audio_get_name(VinylFallbackSound));
            return _voice;
        }
        else
        {
            return _function(_loop, _gain, _pitch);
        }
    }
}