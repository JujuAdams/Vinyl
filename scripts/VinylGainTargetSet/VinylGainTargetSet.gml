/// @param vinylID/labelName
/// @param targetGain
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]
/// @param [stopAtSilence=true]
/// @param [shutdown=true]

function VinylGainTargetSet(_id, _targetGain, _rate = VINYL_DEFAULT_GAIN_RATE, _stopAtSilence = true, _shutdown = true)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputGainTargetSet(_targetGain, _rate, _stopAtSilence, _shutdown);
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputGainTargetSet(_targetGain, _rate, _stopAtSilence, _shutdown);
}