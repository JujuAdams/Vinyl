/// @param voiceOrArray
/// @param factor

function __VinylMultiplyPitch(_voiceOrArray, _factor)
{
    static _staticFlatArray = [];
    
    var _flatArray = _staticFlatArray;
    VinylGetFlatVoiceArray(_voiceOrArray, _flatArray);
    
    var _i = 0;
    repeat(array_length(_flatArray))
    {
        var _voice = _flatArray[_i];
        audio_sound_pitch(_voice, _factor*audio_sound_get_pitch(_voice));
        ++_i;
    }
    
    array_resize(_flatArray, 0);
}