/// @param x
/// @param y
/// @param radius

function VinylEmitterCircle(_x, _y, _radius)
{
    var _emitterRef = new __VinylClassEmitterRef();
    _emitterRef.Circle(_x, _y, _radius);
    return _emitterRef;
}