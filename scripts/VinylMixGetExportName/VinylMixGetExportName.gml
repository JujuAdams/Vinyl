/// Returns the export name for a mix group, as set by `VinylDefineMixGroup()`.
/// 
/// @param mixGroupIndex

function VinylMixGetExportName(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? undefined : _mixGroup.__exportName;
}