/// Returns the gain for a voice, not including the sound gain (as set by `VinylDefineSound()`) or
/// the mix group gain. If an array of voices is provided then this function returns an array of
/// gains that correlate with the input voices.
/// 
/// @param voiceOrArray

function VinylGetGain(_voiceOrArray)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_voiceOrArray))
    {
        var _result = array_create(array_length(_voiceOrArray), 0);
        
        var _i = 0;
        repeat(array_length(_voiceOrArray))
        {
            _result[@ _i] = VinylGetGain(_voiceOrArray[_i]);
            ++_i;
        }
        
        return _result;
    }
    else if (is_struct(_voiceOrArray))
    {
        return _voiceOrArray.ImplGetGain();
    }
    else if (_voiceOrArray != undefined)
    {
        if (audio_is_playing(_voiceOrArray))
        {
            var _soundDef = _soundDefMap[? audio_sound_get_asset(_voiceOrArray)];
            var _soundGain = (_soundDef == undefined)? 1 : _soundDef.__gain;
            return audio_sound_get_gain(_voiceOrArray) / _soundGain;
        }
    }
    
    return 0;
}