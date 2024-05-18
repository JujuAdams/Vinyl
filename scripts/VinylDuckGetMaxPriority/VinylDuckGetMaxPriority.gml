// Feather disable all

/// @param duckName

function VinylDuckGetMaxPriority(_name)
{
    static _duckDict = __VinylSystem().__duckDict;
    
    var _duckStruct = _duckDict[$ _duckName];
    if (_duckStruct == undefined) return;
    
    return _duckStruct.__maxPriority;
}