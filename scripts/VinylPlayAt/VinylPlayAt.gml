// Feather disable all

/// Plays a sound or pattern. Sound playback works the same as native GameMaker functions. If you
/// are playing a pattern, the exact playback behaviour will change depending on the type of
/// pattern:
/// 
///   - Shuffle chooses a random sound from an array of sounds
///   - Blend plays multiple sounds whose balance can be adjusted by setting the blend factor
///   - Head-Loop-Tail plays a head, then a loop (until the end loop function is called), then a tail
/// 
/// This function returns a voice index which can be used with other Vinyl functions to adjust
/// playback and trigger pattern behaviours where relevant.
/// 
/// @param sound/pattern
/// @param x
/// @param y
/// @param z
/// @param [loop]
/// @param [gain=1]
/// @param [pitch=1]
/// @param [duckerName]
/// @param [duckPriority]
/// @param [effectBus]

function VinylPlayAt(_pattern, _x, _y, _z, _loop = undefined, _gain = 1, _pitch = 1, _duckerName = undefined, _duckPrio = undefined, _effectBus = undefined)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    var _volatileEmitter = new __VinylClassVolatileEmitter(_x, _y, _z, _effectBus);
    var _voice = VinylPlayOn(_volatileEmitter.__emitter, _pattern, _loop, _gain, _pitch, _duckerName, _duckPrio);
    _volatileEmitter.__voice = _voice;
    
    return _voice;
}