/// Sets the pitch of a Vinyl playback instance, or Vinyl label
/// Setting pitch with this function immediately resets the pitch target (as set by VinylPitchTargetSet())
/// 
/// If this function is given a label name then all currently playing audio assigned with that label will
/// be immediately affected by the change in the label's pitch state
///
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param semitones

function VinylTransposeSet(_id, _semitone)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__TransposeSet(_semitone);
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__TransposeSet(_semitone);
}