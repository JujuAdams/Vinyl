/// Sets the persistence state of a Vinyl instance
/// 
/// If passed a label name, every audio instance currently assigned to the label will
/// individually have its persistence state set. This is the same as calling VinylPersistentSet()
/// for each individual audio instance
/// 
/// This function CANNOT be used with audio played using VinylPlaySimple()
/// 
/// @param vinylID/labelName
/// @param state

function VinylPersistentSet(_id, _state)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _instance.__PersistentSet(_state);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__PersistentSet(_state);
    
    __VinylTrace("Warning! Failed to execute VinylLoopSet() for ", _id);
}