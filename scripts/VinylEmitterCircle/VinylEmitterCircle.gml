/// @param x
/// @param y
/// @param radius

function VinylEmitterCircle(_x, _y, _radius)
{
    var _emitter = __VinylDepoolEmitter();
    _emitter.__Circle(_x, _y, _radius);
    return _emitter;
}