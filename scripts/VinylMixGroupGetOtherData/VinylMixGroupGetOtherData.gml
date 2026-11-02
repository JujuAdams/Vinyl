/// Returns the additional "other data" for a mix group, as set by `VinylDefineMixGroup()`.
/// 
/// @param mixGroupIndex

function VinylMixGroupGetOtherData(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? undefined : _mixGroup.__otherData;
}