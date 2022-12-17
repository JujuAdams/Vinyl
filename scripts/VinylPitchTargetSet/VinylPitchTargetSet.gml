/// @param vinylID/labelName
/// @param targetPitch
/// @param [rate=VINYL_DEFAULT_PITCH_RATE]
/// @param [stopOnTarget=false]

function VinylPitchTargetSet(_id, _targetPitch, _rate = VINYL_DEFAULT_PITCH_RATE, _stopOnTarget = false)
{
	var _instance = global.__vinylIdToInstanceDict[? _id];
	if (is_struct(_instance)) return _instance.__InputPitchTargetSet(_targetPitch, _rate, _stopOnTarget);
	
	var _label = global.__vinylLabelDict[$ _id];
	if (is_struct(_label)) return _label.__InputPitchTargetSet(_targetPitch, _rate, _stopOnTarget);
}