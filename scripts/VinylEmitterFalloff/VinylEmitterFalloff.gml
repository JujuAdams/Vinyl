/// Sets the falloff properties for the given Vinyl emitter
/// This function will not work with native GameMaker emitters
/// 
/// @param emitter
/// @param min
/// @param max
/// @param factor

function VinylEmitterFalloff(_emitter, _min, _max, _factor)
{
    if (_emitter == undefined) return;
    _emitter.__Falloff(_min, _max, _factor);
}