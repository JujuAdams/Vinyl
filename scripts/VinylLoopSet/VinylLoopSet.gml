/// Sets the looping state of a Vinyl instance. If an instance currently has loop points
/// enabled then turning off looping (setting state to <false>) will disable the loop points
/// and allow the audio to play to the end
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param state

function VinylLoopSet(_id, _state)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__LoopSet(_state);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__LoopSet(_state);
    
    __VinylTrace("Warning! Failed to execute VinylLoopSet() for ", _id);
}