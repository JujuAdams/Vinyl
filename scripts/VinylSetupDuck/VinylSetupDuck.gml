// Feather disable all

/// @param duckName
/// @param [duckedGain=0]
/// @param [rateOfChange=0.05]
/// @param [pauseOnDuck=true]

function VinylSetupDuck(_duckName, _duckedGain = 0, _rateOfChange = __VINYL_DEFAULT_DUCK_RATE_OF_GAIN, _pauseOnDuck = true)
{
    static _system    = __VinylSystem();
    static _duckDict  = _system.__duckDict;
    static _duckArray = _system.__duckArray;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _duckDict[$ _duckName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_duckedGain, _rateOfChange, _pauseOnDuck);
    }
    else
    {
        var _duckStruct = new __VinylClassDuck(_duckName, _duckedGain, _rateOfChange, _pauseOnDuck);
        _duckDict[$ _duckName] = _duckStruct;
        array_push(_duckArray, _duckStruct);
    }
    
    if (VINYL_LIVE_EDIT && (not _system.__importingJSON))
    {
        __VinylResolveChanges(false);
    }
}