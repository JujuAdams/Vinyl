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
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) _instance.__Resume();
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__Resume();
    
    __VinylTrace("Warning! Failed to execute VinylResume() for ", _id);
}