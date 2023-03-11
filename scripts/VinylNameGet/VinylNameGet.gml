/// Returns the name of a Vinyl voice, pattern, or label
/// 
/// @param value

function VinylNameGet(_value)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _value];
    if (is_struct(_voice)) return string(_voice);
    
    var _pattern = __VinylPatternGet(_value);
    if (is_struct(_pattern)) return string(_pattern);
    
    var _label = _globalData.__labelDict[$ _value];
    if (is_struct(_label)) return string(_label);
    
    return undefined;
}