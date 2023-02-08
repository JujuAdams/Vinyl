/// @param emitter
/// @param min
/// @param max
/// @param factor

function VinylEmitterFalloff(_emitter, _min, _max, _factor)
{
    if (_emitter == undefined) return;
    _emitter.__Falloff(_min, _max, _factor);
}