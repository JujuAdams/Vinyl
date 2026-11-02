/// @param mixGroupIndex
/// @param index
/// @param effect

function VinylMixSetEffect(_mixGroupIndex, _effectIndex, _effect)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    if (_mixGroup != undefined)
    {
        return;
    }
    
    if ((_effectIndex < 0) || (_effectIndex > 3))
    {
        __VinylTrace($"Effect index must be between 0 and 3 inclusive (was given {_effectIndex})");
        return;
    }
    
    _mixGroup.__SetEffect(_effectIndex, _effect);
}