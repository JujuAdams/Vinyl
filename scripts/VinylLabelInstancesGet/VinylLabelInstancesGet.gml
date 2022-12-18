/// @param labelName

function VinylLabelInstancesGet(_id)
{
    if (_id == undefined) return [];
    
    var _label = global.__vinylLabelDict[$ _id];
    return is_struct(_label)? _label.__audioArray : [];
}