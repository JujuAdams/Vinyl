/// Returns the current input gain target for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylGainTargetGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__gainTarget;
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__gainTarget;
    
    return VINYL_SILENCE;
}