/// Returns the current input pitch for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylPitchGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__inputPitch;
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__inputPitch;
    
    return 0;
}