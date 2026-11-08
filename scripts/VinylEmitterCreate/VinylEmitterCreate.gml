/// Creates a Vinyl-specific emitter. Vinyl emitters may be used with `VinylPlayOn()` as well as
/// other Vinyl emitter-related functions. If you are making a 2D game, you should probably set
/// `z` to `0`.
/// 
/// By default, a Vinyl emitter will support every mix group that is set to allow emitters (see
/// `VinylDefineMixGroup()`). If you try to use an emitter to play audio assigned to a mix group
/// that does not allow emitters then an error will be shown. You may override this behaviour by
/// specifying mix groups you want to allow by passing an array as the `forceMixGroupArray`
/// parameter.
/// 
/// @param x
/// @param y
/// @param z
/// @param [forceMixGroupArray]

function VinylEmitterCreate(_x, _y, _z, _forceMixGroupArray = undefined)
{
    static _emptyArray = [];
    
    return new __VinylClassEmitter(_x, _y, _z, _forceMixGroupArray ?? _emptyArray);
}