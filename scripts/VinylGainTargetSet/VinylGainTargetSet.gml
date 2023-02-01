/// Sets the input gain target for a Vinyl playback instance, or a Vinyl label
/// The input gain will approach the target smoothly over a few frames, determined by the rate#
/// 
/// If this function is given a label name then all currently playing audio assigned with that label will
/// be affected by the change in the label's gain state
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param targetGain
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylGainTargetSet(_id, _targetGain, _rate = VINYL_DEFAULT_GAIN_RATE)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputGainTargetSet(_targetGain, _rate);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputGainTargetSet(_targetGain, _rate);
}