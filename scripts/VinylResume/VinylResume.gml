/// Resumes a paused Vinyl playback instance, or all audio playing with the given label
/// 
/// If passed a label name, every audio instance currently assigned to the label will
/// individually be resumed. This is the same as calling VinylResume() for each individual
/// audio instance. The label itself has no "is paused" state
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName

function VinylResume(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    if (is_struct(_instance)) _instance.__Resume();
    
    if (_id == undefined) return;
    
    var _label = global.__vinylLabelDict[$ _id];
    if (is_struct(_label)) return _label.__Resume();
}