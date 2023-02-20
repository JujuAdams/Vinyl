/// @param vinylID
/// @param state

function VinylMultiSyncSet(_id, _state)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiSyncSet(_state);
}