// Feather disable all

/// @param duckerName

function VinylDuckerGetMaxVoice(_duckerName)
{
    static _duckerDict = __VinylSystem().__duckerDict;
    
    var _duckerStruct = _duckerDict[$ _duckerName];
    if (_duckerStruct == undefined) return;
    
    return _duckerStruct.__Get(_duckerStruct.__maxPriority);
}