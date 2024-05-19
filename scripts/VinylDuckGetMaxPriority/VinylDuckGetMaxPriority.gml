// Feather disable all

/// @param duckerName

function VinylDuckerGetMaxPriority(_name)
{
    static _duckerDict = __VinylSystem().__duckerDict;
    
    var _duckerStruct = _duckerDict[$ _duckerName];
    if (_duckerStruct == undefined) return;
    
    return _duckerStruct.__maxPriority;
}