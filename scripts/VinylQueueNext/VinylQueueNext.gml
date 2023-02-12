/// @param vinylID

function VinylQueueNext(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__QueueNext();
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__QueueNext();
}