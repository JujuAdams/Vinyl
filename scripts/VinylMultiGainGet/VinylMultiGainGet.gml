/// Returns the gain for a specific channel for a Multi instance
/// 
/// @param vinylID
/// @param index

function VinylMultiGainGet(_id, _index)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiGainGet(_index);
}