/// @param vinylID/labelName
/// @param pitch

function VinylPitchSet(_id, _pitch)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__InputPitchSet(_pitch);
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__InputPitchSet(_pitch);
}