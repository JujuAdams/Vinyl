/// Returns the audio asset playing for the Vinyl voice or pattern
/// 
/// @param value

function VinylAssetGet(_value)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _value];
    if (is_struct(_voice)) return _voice.__pattern.__AssetGet();
    
    var _pattern = __VinylPatternGet(_value);
    if (is_struct(_pattern)) return _pattern.__AssetGet();
    
    return undefined;
}