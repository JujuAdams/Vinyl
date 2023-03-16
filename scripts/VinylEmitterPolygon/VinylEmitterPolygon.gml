/// Creates a Vinyl polygon emitter and returns a reference to it
/// 
/// @param radius
/// @param pointArray

function VinylEmitterPolygon(_radius, _pointArray)
{
    var _emitterRef = new __VinylClassEmitterRef();
    _emitterRef.__Polygon(_radius, _pointArray);
    return _emitterRef;
}