/// Returns the number of playback instance IDs being played for a given Vinyl label
/// 
/// @param labelName

function VinylLabelInstancesCountGet(_id)
{
    if (_id == undefined) return 0;
    
    var _label = global.__vinylLabelDict[$ _id];
    return is_struct(_label)? array_length(_label.__audioArray) : 0;
}