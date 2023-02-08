/// @param emitter

function VinylEmitterDestroy(_emitter)
{
    if (_emitter == undefined) return;
    _emitter.__Destroy();
}