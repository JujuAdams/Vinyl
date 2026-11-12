/// Plays a "playable". This sound will not be panned relative the listener and will appear to come
/// from all around the player's head.
/// 
/// The following is a list of valid playables:
/// 
/// - Sound asset added to the project via the GameMaker IDE
/// - Sound created with `audio_create_stream()`
/// - Sound created with `audio_create_buffer_sound()`
/// - Certain types of Vinyl logic; see documentation per logic for more details
/// - An array of any of the preceeding resources (arrays can be nested inside each other)
/// 
/// @param playable
/// @param [loop=false]
/// @param [gain=1]
/// @param [pitch=1]

function VinylPlay(_playable, _loop = false, _gain = 1, _pitch = 1)
{
    static _mixGroupArray = __VinylSystem().__mixGroupArray;
    static _soundDefMap   = __VinylSystem().__soundDefMap;
    
    if (is_array(_playable))
    {
        var _voiceArray = array_create(array_length(_playable), -1);
        
        var _i = 0;
        repeat(array_length(_playable))
        {
            _voiceArray[@ _i] = VinylPlay(_playable[_i], _loop, _gain, _pitch);
            ++_i;
        }
        
        return _voiceArray;
    }
    else if (is_struct(_playable))
    {
        return _playable.ImplPlay(_loop, _gain, _pitch);
    }
    else if (_playable != undefined)
    {
        var _soundDef = _soundDefMap[? _playable];
        if (_soundDef != undefined)
        {
            var _voice = audio_play_sound_on(_mixGroupArray[_soundDef.__mixGroupIndex].__globalGMEmitterAndBus.__gmEmitter, _playable, _loop, 0, _gain*_soundDef.__gain, 0, _pitch);
        }
        else
        {
            __VinylTrace($"Warning! Sound \"{audio_get_name(_playable)}\" has not been assigned to a mix group, sound playing on master bus");
            var _voice = audio_play_sound(_playable, 0, _loop, _gain, 0, _pitch);
        }
        
        return _voice;
    }
    
    return -1;
}