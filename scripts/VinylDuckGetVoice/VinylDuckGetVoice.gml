// Feather disable all

/// @param duckName
/// @param priority

function VinylDuckGetVoice(_duckName, _priority)
{
    static _duckDict = __VinylSystem().__duckDict;
    
    var _duckStruct = _duckDict[$ _duckName];
    if (_duckStruct == undefined) return;
    
    return _duckStruct.__Get(_priority);
}