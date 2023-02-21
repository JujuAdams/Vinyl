/// Returns the blend factor for a Vinyl Multi instance
/// If no blend has been set then this function will return <undefined>
/// 
/// @param vinylID

function VinylMultiBlendGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiBlendGet();
}