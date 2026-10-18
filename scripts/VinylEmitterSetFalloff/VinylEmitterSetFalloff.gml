/// @param emitter
/// @param refDist
/// @param maxDist
/// @param factor

function VinylEmitterSetFalloff(_emitter, _refDist, _maxDist, _factor)
{
    if (_emitter == undefined) return;
    _emitter.__SetFalloff(_refDist, _maxDist, _factor);
}