/// Returns the gain for a mix group, not including the "trim gain" set by `VinylDefineMixGroup()`.
/// 
/// @param mixGroupIndex

function VinylMixGroupGetGain(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? 0 : (_mixGroup.__gain / _mixGroup.__trim);
}