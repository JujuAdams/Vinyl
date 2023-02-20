/// @param vinylID
/// @param asset
/// @param [dontRepeatLast=false]

function VinylQueuePush(_id, _asset, _dontRepeatLast = false)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__QueuePush(_asset, _dontRepeatLast);
}