/// @param vinylID
/// @param index
/// @param gain

function VinylMultiGainSet(_id, _index, _gain)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiGainSet(_index, _gain);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__MultiGainSet(_behavior);
    
    __VinylTrace("Warning! Failed to execute VinylMultiGainSet() for ", _id);
}