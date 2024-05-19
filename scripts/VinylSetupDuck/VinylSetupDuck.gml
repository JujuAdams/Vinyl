// Feather disable all

/// @param duckerName
/// @param [duckedGain=0]
/// @param [rateOfChange=1]
/// @param [pauseOnDuck=false]

function VinylSetupDucker(_duckerName, _duckedGain = 0, _rateOfChange = __VINYL_DEFAULT_DUCK_RATE_OF_GAIN, _pauseOnDuck = false)
{
    static _system    = __VinylSystem();
    static _duckerDict  = _system.__duckerDict;
    static _duckerArray = _system.__duckerArray;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _duckerDict[$ _duckerName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_duckedGain, _rateOfChange, _pauseOnDuck);
    }
    else
    {
        var _duckerStruct = new __VinylClassDucker(_duckerName, _duckedGain, _rateOfChange, _pauseOnDuck);
        _duckerDict[$ _duckerName] = _duckerStruct;
        array_push(_duckerArray, _duckerStruct);
    }
    
    if (VINYL_LIVE_EDIT && (not _system.__importingJSON))
    {
        __VinylResolveChanges(false);
    }
}