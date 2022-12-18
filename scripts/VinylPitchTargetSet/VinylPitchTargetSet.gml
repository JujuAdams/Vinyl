/// @param vinylID/labelName
/// @param targetPitch
/// @param [rate=VINYL_DEFAULT_PITCH_RATE]
/// @param [stopOnTarget=false]
/// @param [shutdown=true]

function VinylPitchTargetSet(_id, _targetPitch, _rate = VINYL_DEFAULT_PITCH_RATE, _stopOnTarget = false, _shutdown = true)
{
	var _instance = global.__vinylIdToInstanceDict[? _id];
	if (is_struct(_instance)) return _instance.__InputPitchTargetSet(_targetPitch, _rate, _stopOnTarget, _shutdown);
	
	var _label = global.__vinylLabelDict[$ _id];
	if (is_struct(_label)) return _label.__InputPitchTargetSet(_targetPitch, _rate, _stopOnTarget, _shutdown);
}