/// @param voiceOrArray
/// @param fadeTime
/// @param [callback]

function VinylFadeOut(_voiceOrArray, _fadeTime, _callback = undefined)
{
    static _strongUpdateArray = __VinylSystem().__strongUpdateArray;
    
    if (is_array(_voiceOrArray))
    {
        if (_callback != undefined)
        {
            if (VINYL_RUNNING_FROM_IDE)
            {
                __VinylDevError("Cannot use a callback with an array of voices");
            }
            else
            {
                __VinylTrace("Warning! Cannot use a callback with an array of voices");
            }
            
            return;
        }
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylFadeOut(_voiceOrArray[_i], _fadeTime);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        VinylFadeOut(_voiceOrArray.ImplGetVoiceForFadeOut(), _fadeTime, _callback);
    }
    else if (_voiceOrArray != undefined)
    {
        VinylAttachUpdateMethod(_voiceOrArray, {
            __startTime: current_time,
            __duration:  max(1, 1000*_fadeTime*audio_sound_get_gain(_voice)),
            __callback:  _callback,
        },
        function(_data, _voiceOrArray, _playing)
        {
            if (_playing)
            {
                var _gain = (current_time - __startTime) / __duration;
                if (_gain >= 0)
                {
                    audio_sound_gain(__voice, _gain, VINYL_STEP_DURATION);
                    return true;
                }
            }
            
            if (is_callable(__callback))
            {
                __callback();
            }
        });
    }
}