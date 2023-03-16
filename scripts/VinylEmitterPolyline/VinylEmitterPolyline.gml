/// Creates a Vinyl linear emitter and returns a reference to it
/// 
/// @param radius
/// @param pointArray

function VinylEmitterPolyline(_radius, _pointArray)
{
    var _emitterRef = new __VinylClassEmitterRef();
    _emitterRef.__Polyline(_radius, _pointArray);
    return _emitterRef;
}