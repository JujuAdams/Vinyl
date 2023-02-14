/// Behaviour value can be one of the following:
///  0: Play the queue once. Assets will be removed from the queue once they finish playing
///  1: Repeat the queue once it's finished. No assets are removed from the queue
///  2: Repeat the last asset in the queue. Assets will be removed from the queue once they finish playing (apart from the last asset)
/// 
/// @param vinylID

function VinylQueueBehaviorGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__BehaviourGet();
}