/// Plays a "playable" on an emitter. Only Vinyl emitters are supported (`VinylEmitterCreate()`).
/// The sound will be panned relative to the listener position, which can be set with
/// `VinylSetListener()`.
/// 
/// Please see `Vinyl Terminology` for information on what counts as a "playable". Typically, a
/// playable is just a sound asset that you've added to the GameMaker IDE.
/// 
/// @param playable
/// @param emitter
/// @param [loop=false]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlayOn(_playable, _emitter, _loop = false, _gain = 1, _pitch = 1)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (_emitter == undefined)
    {
        return -1;
    }
    
    if (is_array(_playable))
    {
        var _voiceArray = array_create(array_length(_playable), -1);
        
        var _i = 0;
        repeat(array_length(_playable))
        {
            _voiceArray[@ _i] = VinylPlayOn(_playable[_i], _emitter, _loop, _gain, _pitch);
            ++_i;
        }
        
        return _voiceArray;
    }
    else if (is_struct(_playable))
    {
        return _playable.ImplPlayOn(_emitter, _loop, _gain, _pitch);
    }
    else if (_playable != undefined)
    {
        //TODO - Check sound exists
        
        var _soundDef = _soundDefMap[? _playable];
        if (_soundDef != undefined)
        {
            var _gmEmitter = _emitter.__gmEmitterAndBusArray[_soundDef.__mixGroupIndex].__gmEmitter;
            if (_gmEmitter == undefined)
            {
                __VinylTrace($"Warning! Mix group (\"{_soundDef.__mixGroupIndex}\") for sound \"{audio_get_name(_playable)}\" cannot be used with emitters");
                return -1;
            }
            
            return audio_play_sound_on(_gmEmitter, _playable, _loop, 0, _gain*_soundDef.__gain, 0, _pitch);
        }
        else
        {
            __VinylTrace($"Warning! Sound \"{audio_get_name(_playable)}\" has not been assigned to a mix group, sound cannot play");
            return -1;
        }
    }
    
    return -1;
}