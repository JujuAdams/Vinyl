/// Fade out a voice, or array of voices, to zero gain at which point the voice(s) will be stopped.
/// You may specify a callback to execute when the fade out has been completed. The fade out cannot
/// be cancelled once started.
/// 
/// @param voiceOrArray
/// @param fadeTime
/// @param [callback]

function VinylFadeOut(_voiceOrArray, _fadeTime, _callback = undefined)
{
    if (_fadeTime <= 0)
    {
        VinylStop(_voiceOrArray);
        
        if (is_callable(_callback))
        {
            _callback();
        }
        
        return;
    }
    
    var _flatArray = VinylGetFlatVoiceArray(_voiceOrArray);
    
    var _maxGain = 0;
    var _gainArray = array_create(array_length(_flatArray), 1);
    var _i = 0;
    repeat(array_length(_flatArray))
    {
        var _gain = audio_sound_get_gain(_flatArray[_i]);
        _gainArray[@ _i] = _gain;
        _maxGain = max(_gain, _maxGain);
        ++_i;
    }
    
    new VinylLogicTick(_voiceOrArray, {
        __voiceOrArray: _voiceOrArray,
        __startTime:    current_time,
        __flatArray:    _flatArray,
        __gainArray:    _gainArray,
        __duration:     max(1, 1000*_fadeTime*_maxGain),
        __callback:     _callback,
    },
    function(_data, _voiceOrArray, _playing)
    {
        with(_data)
        {
            if (_playing)
            {
                var _flatArray = __flatArray;
                
                var _factor = 1 - ((current_time - __startTime) / __duration);
                if (_factor > 0)
                {
                    var _gainArray = __gainArray;
                    var _i = 0;
                    repeat(array_length(_flatArray))
                    {
                        audio_sound_gain(_flatArray[_i], _factor*_gainArray[_i], VINYL_STEP_DURATION);
                        ++_i;
                    }
                    
                    return true;
                }
                
                VinylStop(__voiceOrArray);
            }
            
            if (is_callable(__callback))
            {
                __callback();
            }
        }
    });
}