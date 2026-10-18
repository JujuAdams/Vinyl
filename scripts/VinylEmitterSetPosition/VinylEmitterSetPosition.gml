/// @param emitter
/// @param x
/// @param y
/// @param z

function VinylEmitterSetPosition(_emitter, _x, _y, _z)
{
    if (_emitter == undefined) return;
    _emitter.__SetPosition(_x, _y, _z);
}