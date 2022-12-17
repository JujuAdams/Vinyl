/// @param vinylID/labelName

function VinylGainTargetGet(_id)
{
	var _instance = global.__vinylIdToInstanceDict[? _id];
	if (is_struct(_instance)) return _instance.__GainTargetGet();
	
	var _label = global.__vinylLabelDict[$ _id];
	if (is_struct(_label)) return _label.__GainTargetGet();
	
	return VINYL_SILENCE;
}