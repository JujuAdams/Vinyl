/// @param x
/// @param y

function VinylEmitterPoint(_x, _y)
{
    var _emitter = __VinylDepoolEmitter();
    _emitter.__Point(_x, _y);
    return _emitter;
}