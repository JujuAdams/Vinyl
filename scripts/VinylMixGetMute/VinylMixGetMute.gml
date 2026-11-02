/// Returns the mute state for a mix group`.
/// 
/// @param mixGroupIndex

function VinylMixGetMute(_mixGroupIndex)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    return (_mixGroup == undefined)? true : _mixGroup.__mute;
}