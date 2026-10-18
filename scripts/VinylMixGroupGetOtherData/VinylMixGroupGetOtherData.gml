/// @param mixGroupIndex

function VinylMixGroupGetOtherData(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? undefined : _mixGroup.__otherData;
}