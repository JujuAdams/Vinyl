// Feather disable all

/// Sets up a blend pattern for playback with Vinyl. When played, a blend pattern will play a
/// mixture of sounds whose composition can be adjusted by setting the blend factor with the
/// VinylSetBlendFactor() and VinylSetBlendAnimCurve() functions.
/// 
/// You should typically only call this function once on boot. Subsequent calls to this function
/// will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even
/// then calls to this function whilst audio is playing is expensive.
/// 
/// @param patternName
/// @param soundArray
/// @param [loop=true]
/// @param [gain=1]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupBlend(_patternName, _soundArray, _loop = true, _gain = 1, _mix = VINYL_DEFAULT_MIX)
{
    static _patternDict = __VinylSystem().__patternDict;
    
    if (_mix == VINYL_NO_MIX) _mix = undefined;
    
    //Update an existing pattern if possible, otherwise make a new pattern
    var _existingPattern = _patternDict[$ _patternName];
    if (_existingPattern != undefined)
    {
        _existingPattern.__UpdateSetup(_soundArray, _loop, _gain, _mix);
    }
    else
    {
        _patternDict[$ _patternName] = new __VinylClassPatternBlend(_patternName, _soundArray, _loop, _gain, _mix);
    }
}