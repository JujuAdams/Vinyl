/// Returns the type for a Vinyl instance
/// 
/// The value returned can be one of the following:
///   "basic"
///   "queue"
///   "multi"
/// 
/// @param vinylID

function VinylTypeGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__patternType;
}