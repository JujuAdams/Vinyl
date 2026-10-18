/// @param voiceOrArray
/// @param factor
/// @param time

function __VinylMultiplyGain(_voiceOrArray, _factor, _time)
{
    static _staticFlatArray = [];
    
    var _flatArray = _staticFlatArray;
    VinylGetFlatVoiceArray(_voiceOrArray, _flatArray);
    
    var _i = 0;
    repeat(array_length(_flatArray))
    {
        var _voice = _flatArray[_i];
        audio_sound_gain(_voice, _factor*audio_sound_get_gain(_voice), _time);
        ++_i;
    }
    
    array_resize(_flatArray, 0);
}