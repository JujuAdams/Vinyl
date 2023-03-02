/// Returns the blend factor for a Vinyl Multi instance
/// If no blend has been set then this function will return <undefined>
/// 
/// @param vinylID

function VinylMultiBlendGet(_id)
{
    static _globalData = __VinylGlobalData();
    static _idToVoiceDict = _globalData.__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _id];
    if (is_struct(_voice)) return _instance.__MultiBlendGet();
}