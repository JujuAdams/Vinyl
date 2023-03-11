/// Returns the audio asset playing for a Vinyl voice
/// 
/// @param voice

function VinylAssetGet(_voice)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _voice];
    if (is_struct(_voice)) return _voice.__AssetGet();
    
    return undefined;
}