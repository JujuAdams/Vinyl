/// @param vinylID/labelName

function VinylGainTargetGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputGainTargetGet();
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputGainTargetGet();
    
    return VINYL_SILENCE;
}