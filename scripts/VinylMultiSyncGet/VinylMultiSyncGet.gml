/// Returns whether a Vinyl Multi instance is set to synchronise channel playback
/// 
/// @param vinylID

function VinylMultiSyncGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _instance = _idToVoiceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiSyncGet();
}