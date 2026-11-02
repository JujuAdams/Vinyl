/// Destroys a Vinyl-specific emitter that has been created by `VinylEmitterCreate()`.
/// 
/// @param emitter

function VinylEmitterDestroy(_emitter)
{
    if (_emitter == undefined) return;
    _emitter.__Destroy();
}