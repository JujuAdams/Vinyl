/// @param soundOrArray
/// @param emitter
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayLoopOn(_soundOrArray, _emitter, _gain = 1, _pitch = 1)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (_emitter == undefined)
    {
        return -1;
    }
    
    if (is_array(_soundOrArray))
    {
        var _voiceArray = array_create(array_length(_soundOrArray), -1);
        
        var _i = 0;
        repeat(array_length(_soundOrArray))
        {
            _voiceArray[@ _i] = VinylPlayLoopOn(_soundOrArray[_i], _emitter, _gain, _pitch);
            ++_i;
        }
        
        return _voiceArray;
    }
    else if (is_struct(_soundOrArray))
    {
        return _soundOrArray.__ImplPlayLoopOn(_emitter);
    }
    else if (_soundOrArray != undefined)
    {
        var _sound = _soundOrArray;
        
        var _soundDef = _soundDefMap[? _sound];
        if (_soundDef != undefined)
        {
            var _gmEmitter = _emitter.__emitbusArray[_soundDef.__mixGroupIndex].__gmEmitter;
            if (_gmEmitter == undefined)
            {
                __VinylTrace($"Warning! Mix group is set as omnidirectional only, sounds in this mix group cannot be used with emitters");
                return -1;
            }
            
            return audio_play_sound_on(_gmEmitter, _sound, true, 0, _gain*_soundDef.__gain, 0, _pitch);
        }
        else
        {
            __VinylTrace($"Warning! Sound \"{audio_get_name(_sound)}\" has not been assigned to a mix group, sound cannot play");
            return -1;
        }
    }
    
    return -1;
}