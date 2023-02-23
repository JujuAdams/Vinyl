/// Returns the number of playback instance IDs being played for a given Vinyl label
/// 
/// @param labelName

function VinylLabelInstanceCountGet(_id)
{
    static _globalData = __VinylGlobalData();
    
    if (_id == undefined) return 0;
    
    var _label = _globalData.__labelDict[$ _id];
    return is_struct(_label)? array_length(_label.__audioArray) : 0;
}