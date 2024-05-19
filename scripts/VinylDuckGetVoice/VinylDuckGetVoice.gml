// Feather disable all

/// @param duckerName
/// @param priority

function VinylDuckerGetVoice(_duckerName, _priority)
{
    static _duckerDict = __VinylSystem().__duckerDict;
    
    var _duckerStruct = _duckerDict[$ _duckerName];
    if (_duckerStruct == undefined) return;
    
    return _duckerStruct.__Get(_priority);
}