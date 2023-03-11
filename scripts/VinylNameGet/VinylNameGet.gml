/// Starts playing a sound and returns an ID to identify the voice
/// 
/// Vinyl IDs are separate from GameMaker's native audio voices IDs and the two sets of
/// IDs cannot be used interchangeably
/// 
/// There is a perfomance overhead when creating and maintaining Vinyl audio voices. In
/// resource-constrained situations, you may want to consider using VinylPlaySimple() for some
/// of your audio
/// 
/// @param value

function VinylNameGet(_value)
{
    static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
    
    var _voice = _idToVoiceDict[? _value];
    if (is_struct(_voice)) return string(_voice);
    
    var _pattern = __VinylPatternGet(_value);
    if (is_struct(_pattern)) return string(_pattern);
    
    return undefined;
}