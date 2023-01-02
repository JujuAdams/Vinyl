/// @param x
/// @param y
/// @param minRange
/// @param maxRange

function VinylEmitterCreate(_x, _y, _min, _max)
{
    _min = max(math_get_epsilon(), _min);
    _max = max(_min + math_get_epsilon(), _max);
    
    var _emitter = audio_emitter_create();
    audio_emitter_position(_emitter, _x, _y, 0);
    audio_emitter_falloff(_emitter, _min, _max, 1);
    
    return _emitter;
}