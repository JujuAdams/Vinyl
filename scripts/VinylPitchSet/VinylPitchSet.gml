/// Sets the pitch of a Vinyl playback instance, or Vinyl label
/// Setting pitch with this function immediately resets the pitch target (as set by VinylPitchTargetSet())
/// 
/// @param vinylID/labelName
/// @param pitch

function VinylPitchSet(_id, _pitch)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputPitchSet(_pitch);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputPitchSet(_pitch);
}