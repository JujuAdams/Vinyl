/// Sets the input gain of a Vinyl playback instance, or Vinyl label
/// Setting gain with this function immediately resets the gain target (as set by VinylGainTargetSet())
/// 
/// @param vinylID/labelName
/// @param gainDB

function VinylGainSet(_id, _gain)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputGainSet(_gain);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputGainSet(_gain);
}