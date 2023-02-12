/// Behaviour value can be one of the following:
///  0: Don't pop anything from the queue
///  1: Pop every asset from the queue
///  2: Pop every asset apart from the last asset
/// 
/// @param vinylID

function VinylQueueBehaviorGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__BehaviourGet();
}