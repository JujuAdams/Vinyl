/// @param vinylID
/// @param blendFactor

function VinylMultiBlendSet(_id, _blendFactor)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiBlendSet(_blendFactor);
    
    var _label = _globalData.__labelDict[$ _id];
    if (is_struct(_label)) return _label.__MultiBlendSet(_blendFactor);
    
    __VinylTrace("Warning! Failed to execute VinylMultiBlendSet() for ", _id);
}