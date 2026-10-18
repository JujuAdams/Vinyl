/// @param mixGroupIndex

function VinylMixGroupGetExportName(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? undefined : _mixGroup.__exportName;
}