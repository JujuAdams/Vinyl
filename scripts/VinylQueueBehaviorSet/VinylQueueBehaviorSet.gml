/// @param vinylID
/// @param behavior

function VinylQueueBehaviorSet(_id, _behavior)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__QueueBehaviorSet(_behavior);
}