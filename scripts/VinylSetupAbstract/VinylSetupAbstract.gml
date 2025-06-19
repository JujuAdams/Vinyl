// Feather disable all

/// Sets up a pattern that can be used to create abstract voices. You can use `VinylAbstract()`
/// to create one-off abstract voices, but by calling `VinylSetupAbstract()` you can instead use
/// `VinylPlay()` to create abstract voices instead.
/// 
/// You should typically only call this function once on boot or if you're reloading configuration
/// data due to the presence of mods. Subsequent calls to this function will only affect audio that
/// is already playing if VINYL_LIVE_EDIT is set to <true>, and even then calls to this function
/// whilst audio is playing is expensive.
/// 
/// @param patternName
/// @param [gain=1]
/// @param [pitch=1]
/// @param [mix=VINYL_DEFAULT_MIX]
/// @param [duckerName]
/// @param [duckPriority=0]
/// @param [metadata]

function VinylSetupAbstract(_patternName, _gain = 1, _pitch = 1, _mixName = VINYL_DEFAULT_MIX, _duckerName = undefined, _duckPrio = undefined, _metadata = undefined)
{
    static _system      = __VinylSystem();
    static _patternDict = _system.__patternDict;
    
    if (is_array(_gain))
    {
        __VinylError("Cannot use an array as gain for an abstract pattern");
    }
    
    if (is_array(_pitch))
    {
        __VinylError("Cannot use an array as pitch for an abstract pattern");
    }
    
    if (_mixName == VINYL_NO_MIX) _mixName = undefined;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _metadata);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternAbstract(_patternName, _gain, _pitch, _mixName, _duckerName, _duckPrio, _metadata);
    }
    
    if (VINYL_LIVE_EDIT && (not _system.__importingJSON))
    {
        __VinylResolveChanges(false);
    }
}