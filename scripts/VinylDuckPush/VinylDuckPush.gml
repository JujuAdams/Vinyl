// Feather disable all

/// @param duckName
/// @param priority
/// @param voice

function VinylDuckPush(_duckName, _priority, _voice)
{
    static _duckDict = __VinylSystem().__duckDict;
    
    var _duckStruct = _duckDict[$ _duckName];
    if (_duckStruct == undefined) return;
    
    return _duckStruct.__Push(_priority, _voice, false);
}