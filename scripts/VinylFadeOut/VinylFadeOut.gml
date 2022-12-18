/// @param vinylID/labelName
/// @param [rate=VINYL_DEFAULT_GAIN_RATE]

function VinylFadeOut(_id, _rate = VINYL_DEFAULT_GAIN_RATE)
{
	var _instance = global.__vinylIdToInstanceDict[? _id];
	if (is_struct(_instance)) return _instance.__InputGainTargetSet(VINYL_SILENCE, _rate, true, true);
	
	var _label = global.__vinylLabelDict[$ _id];
	if (is_struct(_label)) return _label.__InputGainTargetSet(VINYL_SILENCE, _rate, true, true);
}