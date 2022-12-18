/// Pauses a Vinyl playback instance
/// 
/// @param vinylID/labelName

function VinylPause(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) _instance.__Pause();
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__Pause();
}