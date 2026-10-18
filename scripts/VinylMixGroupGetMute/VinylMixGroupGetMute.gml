/// @param mixGroupIndex

function VinylMixGroupGetMute(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? true : _mixGroup.__mute;
}