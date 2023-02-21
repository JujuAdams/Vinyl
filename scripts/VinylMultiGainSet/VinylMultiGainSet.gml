/// Sets the gain for a channel for a Vinyl Multi instance, or Vinyl label
/// This gain is applied multiplicatively with the overall gain of the Multi instance
/// Setting a channel gain with this function overrides VinylMultiBlendSet()
/// 
/// If this function is given a label name then all current multi instances assigned to that label
/// will have their channel gain adjusted
/// 
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
    if (is_struct(_label)) return _label.__MultiGainSet(_index, _gain);
    
    __VinylTrace("Warning! Failed to execute VinylMultiGainSet() for ", _id);
}