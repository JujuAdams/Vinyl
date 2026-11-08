/// Defines a mix group for use elsewhere with Vinyl. Each mix group should be given a unique
/// index that can be used to refer to the mix group. The best way to manage mix group indexes is
/// by using macros or an enum (though it's up to you to set that up).
/// 
/// The `exportName` parameter is used when calling `VinylSettings*()` and is used to match data
/// in settings to the the mix group in the game.
/// 
/// N.B. If you change an export name then exported settings for the mix group will no longer be
///      imported. Be very careful when modifying mix groups.
/// 
/// The `allowEmitters` parameter allows emitters to play sounds associated with the mix group. The
/// advantage to setting a mix group to disallow emitters is that it reduces the amount of work
/// Vinyl has to do to update emitters. Try to set mix groups to disallow emitters where possible e.g.
/// a mix group intended to play music should likely be set to disallow emitters but a mix group
/// intended to play sound effects should likely be set to allow emitters.
/// 
/// `trimGain` applies a multiplicative gain to the mix group regardless of other settings. This is
/// useful to tweak relative volumes of different kinds of audio without having to adjust how
/// `VinylMixSetGain()` affects each individual mix group.
/// 
/// To add miscellaneous data to a mix group, use the `otherData` parameter. You can later retrieve
/// this data by calling `VinylMixGetOtherData()`.
/// 
/// @param mixGroupIndex
/// @param exportName
/// @param allowEmitters
/// @param [trimGain=1]
/// @param [otherData]

function VinylDefineMixGroup(_mixGroupIndex, _exportName, _allowEmitters, _trimGain = 1, _otherData = undefined)
{
    static _system = __VinylSystem();
    static _mixGroupArray = _system.__mixGroupArray;
    
    if (__VinylGetMixGroup(_mixGroupIndex) != undefined)
    {
        __VinylTrace("Warning! Cannot redefine a mix group");
        return;
    }
    
    var _mixGroup = new __VinylClassMixGroup(_mixGroupIndex, _exportName, _allowEmitters, _trimGain, _otherData);
    _mixGroupArray[@ _mixGroupIndex] = _mixGroup;
}