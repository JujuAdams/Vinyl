/// @param left
/// @param top
/// @param right
/// @param bottom

function VinylEmitterRectangle(_left, _top, _right, _bottom)
{
    var _emitter = __VinylDepoolEmitter();
    _emitter.__Rectangle(_left, _top, _right, _bottom);
    return _emitter;
}