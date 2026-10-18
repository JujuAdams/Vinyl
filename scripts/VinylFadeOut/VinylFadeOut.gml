/// @param voiceOrArray
/// @param fadeTime
/// @param [callback]

function VinylFadeOut(_voiceOrArray, _fadeTime, _callback = undefined)
{
    static _strongUpdateArray = __VinylSystem().__strongUpdateArray;
    
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
    
    VinylCreateUpdateMethod(_voiceOrArray, {
        __startTime: current_time,
        __flatArray: _flatArray,
        __gainArray: _gainArray,
        __duration:  max(1, 1000*_fadeTime*_maxGain),
        __callback:  _callback,
    },
    function(_data, _voiceOrArray, _playing)
    {
        if (_playing)
        {
            var _flatArray = _data.__flatArray;
            
            var _factor = (current_time - __startTime) / __duration;
            if (_factor >= 0)
            {
                var _gainArray = _data.__gainArray;
                var _i = 0;
                repeat(array_length(_flatArray))
                {
                    audio_sound_gain(_flatArray[_i], _factor*_gainArray[_i], VINYL_STEP_DURATION);
                    ++_i;
                }
                
                return true;
            }
            
            var _i = 0;
            repeat(array_length(_flatArray))
            {
                audio_stop_sound(_flatArray[_i]);
                ++_i;
            }
        }
            
        if (is_callable(__callback))
        {
            __callback();
        }
    });
}