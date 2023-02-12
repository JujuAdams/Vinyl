/// Behaviour value can be one of the following:
///  0: Don't pop anything from the queue
///  1: Pop every asset from the queue
///  2: Pop every asset apart from the last asset
/// 
/// @param vinylID
/// @param behaviour

function VinylQueueBehaviorSet(_id, _behaviour)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__BehaviourSet(_behaviour);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__BehaviourSet(_behaviour);
}