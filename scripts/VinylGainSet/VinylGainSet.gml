/// @param vinylID/labelName
/// @param gain

function VinylGainSet(_id, _gain)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputGainSet(_gain);
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputGainSet(_gain);
}