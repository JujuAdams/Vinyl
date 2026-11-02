/// Creates a Vinyl-specific emitter. Vinyl emitters may be used with `VinylPlayOn()` as well as
/// other Vinyl emitter-related functions. If you are making a 2D game, you should probably set
/// `z` to `0`.
/// 
/// @param x
/// @param y
/// @param z

function VinylEmitterCreate(_x, _y, _z)
{
    return new __VinylClassEmitter(_x, _y, _z);
}