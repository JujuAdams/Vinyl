/// @param mixGroupIndex

function VinylMixGroupGetGain(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? 0 : (_mixGroup.__gain / _mixGroup.__trim);
}