/// @param vinylID/labelName

function VinylGainGet(_id)
{
	var _instance = global.__vinylIdToInstanceDict[? _id];
	if (is_struct(_instance)) return _instance.__GainGet(_gain);
	
	var _label = global.__vinylLabelDict[$ _id];
	if (is_struct(_label)) return _label.__GainGet(_gain);
}