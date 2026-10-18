/// @param soundOrArray
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayOmni(_soundOrArray, _gain = 1, _pitch = 1)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    static _soundDefMap   = __VinylSystem().__soundDefMap;
    
    if (is_array(_soundOrArray))
    {
        var _voiceArray = array_create(array_length(_soundOrArray), -1);
        
        var _i = 0;
        repeat(array_length(_soundOrArray))
        {
            _voiceArray[@ _i] = VinylPlayOmni(_soundOrArray[_i], _gain, _pitch);
            ++_i;
        }
        
        return _voiceArray;
    }
    else if (is_struct(_soundOrArray))
    {
        return _soundOrArray.__ImplPlayOmni(_soundOrArray, _gain, _pitch);
    }
    else
    {
        var _sound = _soundOrArray;
        
        var _soundDef = _soundDefMap[? _sound];
        if (_soundDef != undefined)
        {
            var _voice = audio_play_sound_on(_mixGroupArray[_soundDef.__mixGroupIndex].__globalEmitbus.__gmEmitter, _sound, false, 0, _gain*_soundDef.__gain, 0, _pitch);
        }
        else
        {
            __VinylTrace($"Warning! Sound \"{audio_get_name(_sound)}\" has not been assigned to a mix group, sound playing on master bus");
            var _voice = audio_play_sound(_sound, 0, false, _gain, 0, _pitch);
        }
        
        return _voice;
    }
}