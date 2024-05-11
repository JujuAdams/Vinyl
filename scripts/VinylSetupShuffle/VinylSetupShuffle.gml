// Feather disable all

/// Sets up a shuffle pattern for playback with Vinyl. When played, a shuffle pattern will randomly
/// choose a sound from an array of sounds when played.
/// 
/// You should typically only call this function once on boot. Subsequent calls to this function
/// will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even
/// then calls to this function whilst audio is playing is expensive.
/// 
/// @param patternName
/// @param soundArray
/// @param [gain=1]
/// @param [pitch=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupShuffle(_patternName, _soundArray, _gain = undefined, _pitch = undefined, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict; 
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    if (_mix == VINYL_NO_MIX) _mix = undefined;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix);
    }
}