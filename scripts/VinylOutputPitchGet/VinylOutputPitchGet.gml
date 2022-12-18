/// Returns the current output pitch for a Vinyl playback instance, or a Vinyl label
/// 
/// @param vinylID/labelName

function VinylOutputPitchGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__outputPitch;
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__outputPitch;
    
    return 0;
}