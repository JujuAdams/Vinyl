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