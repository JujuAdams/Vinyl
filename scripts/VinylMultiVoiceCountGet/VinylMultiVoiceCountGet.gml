/// Returns the number of voices being played on a Vinyl Multi instance
/// 
/// @param vinylID

function VinylMultiVoiceCountGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _instance.__MultiChannelCountGet();
}