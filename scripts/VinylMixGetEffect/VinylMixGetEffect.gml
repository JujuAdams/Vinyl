/// Returns the mix group effect struct for the given index.
/// 
/// @param mixGroupIndex
/// @param effectIndex

function VinylMixGetEffect(_mixGroupIndex, _effectIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    if (_mixGroup != undefined)
    {
        return undefined;
    }
    
    if ((_effectIndex < 0) || (_effectIndex > 3))
    {
        __VinylTrace($"Effect index must be between 0 and 3 inclusive (was given {_effectIndex})");
        return undefined;
    }
    
    return _mixGroup.__globalGMEmitterAndBus.__bus.effects[4 + _effectIndex];
}