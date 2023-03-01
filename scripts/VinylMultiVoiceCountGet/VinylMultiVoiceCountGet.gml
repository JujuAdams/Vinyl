/// Returns the number of voices being played on a Vinyl Multi instance
/// 
/// @param vinylID

function VinylMultiVoiceCountGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToInstanceDict = _globalData.__idToInstanceDict;
    
    var _instance = _idToInstanceDict[? _id];
    if (is_struct(_instance)) return _instance.__MultiChannelCountGet();
}