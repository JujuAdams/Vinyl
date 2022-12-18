/// @param vinylID/labelName

function VinylOutputPitchGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__OutputPitchGet();
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__OutputPitchGet();
    
    return 0;
}