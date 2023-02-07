/// Returns the current playback instance IDs for a VInyl label as an array
///   N.B. Do not edit this array! Doing so will lead to undefined behaviour
/// 
/// @param labelName

function VinylLabelInstancesGet(_id)
{
    static _globalData = __VinylGlobalData();
    
    if (_id == undefined) return [];
    
    var _label = _globalData.__labelDict[$ _id];
    return is_struct(_label)? _label.__audioArray : [];
}