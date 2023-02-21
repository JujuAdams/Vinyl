/// Sets the falloff properties for the given Vinyl emitter
/// This function will not work with native GameMaker emitters
/// 
/// @param emitter
/// @param min
/// @param max
/// @param factor

function VinylEmitterFalloffSet(_emitter, _min, _max, _factor)
{
    if (_emitter == undefined) return;
    _emitter.__FalloffSet(_min, _max, _factor);
}