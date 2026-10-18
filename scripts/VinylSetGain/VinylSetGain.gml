/// @param voiceOrArray
/// @param gain
/// @param [time=0]

function VinylSetGain(_voiceOrArray, _gain, _time = 0)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_voiceOrArray))
    {
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            VinylSetGain(_voiceOrArray[_i], _gain, _time);
            ++_i;
        }
    }
    else if (is_struct(_voiceOrArray))
    {
        _voiceOrArray.ImplSetGain(_gain, _time);
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            var _soundDef = _soundDefMap[? audio_sound_get_asset(_voiceOrArray)];
            var _soundGain = (_soundDef == undefined)? 1 : _soundDef.__gain;
            audio_sound_gain(_voiceOrArray, _gain*_soundGain, _time);
        }
    }
}