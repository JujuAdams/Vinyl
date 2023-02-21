/// Sets the synchronisation state for a Vinyl Multi instance, or Vinyl label
/// 
/// If this function is given a label name then all current multi instances assigned to that label
/// will have their synchronisation state adjusted
/// 
/// @param vinylID
/// @param state

function VinylMultiSyncSet(_id, _state)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiSyncSet(_state);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__MultiSyncSet(_state);
    
    __VinylTrace("Warning! Failed to execute VinylMultiSyncSet() for ", _id);
}