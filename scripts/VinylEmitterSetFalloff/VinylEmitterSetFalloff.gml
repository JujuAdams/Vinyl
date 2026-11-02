/// Sets the falloff properties of a Vinyl emitter (created by `VinylEmitterCreate()`). Please
/// see GameMaker's native documentation for `audio_emitter_falloff()` for further details.
/// 
/// @param emitter
/// @param refDist
/// @param maxDist
/// @param factor

function VinylEmitterSetFalloff(_emitter, _refDist, _maxDist, _factor)
{
    if (_emitter == undefined) return;
    _emitter.__SetFalloff(_refDist, _maxDist, _factor);
}