// Feather disable all

/// Pauses all voices currently playing in a given mix. These voices can be individually resumed
/// using VinylResume() or can be resumed all together with VinylMixResumeVoices().
/// 
/// @param mixName

function VinylMixPauseVoices(_mixName)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__PauseVoices();
}