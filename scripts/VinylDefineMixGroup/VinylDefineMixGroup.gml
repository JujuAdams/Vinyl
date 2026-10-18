/// @param mixGroupIndex
/// @param exportName
/// @param omniOnly
/// @param [trim=1]
/// @param [otherData]

function VinylDefineMixGroup(_mixGroupIndex, _exportName, _omniOnly, _trim = 1, _otherData = undefined)
{
    static _system = __VinylSystem();
    static _mixGroupArray = _system.__mixGroupArray;
    
    if (__VinylGetMixGroup(_mixGroupIndex) != undefined)
    {
        __VinylTrace("Warning! Cannot redefine a mix group");
        return;
    }
    
    var _mixGroup = new __VinylClassMixGroup(_mixGroupIndex, _exportName, _omniOnly, _trim, _otherData);
    _mixGroupArray[@ _mixGroupIndex] = _mixGroup;
}