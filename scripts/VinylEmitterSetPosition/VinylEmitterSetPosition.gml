/// Sets the position of a Vinyl emitter (created by `VinylEmitterCreate()`). If you are making a
/// 2D game, you should probably set `z` to `0`.
/// 
/// @param emitter
/// @param x
/// @param y
/// @param z

function VinylEmitterSetPosition(_emitter, _x, _y, _z)
{
    if (_emitter == undefined) return;
    _emitter.__SetPosition(_x, _y, _z);
}