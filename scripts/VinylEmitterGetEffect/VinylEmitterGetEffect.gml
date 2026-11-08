/// Returns the emitter effect struct for the given index.
/// 
/// @param emitter
/// @param effectIndex

function VinylEmitterGetEffect(_emitter, _effectIndex)
{
    if ((_effectIndex < 0) || (_effectIndex > 3))
    {
        __VinylError($"Effect index must be an integer between 0 and 3 inclusive (got {_effectIndex})");
    }
    
    if (_emitter == undefined) return;
    
    return _emitter.__bus.effects[@ _effectIndex];
}