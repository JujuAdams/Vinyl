// Feather disable all

/// Resumes all voices currently playing in a given mix.
/// 
/// @param mixName

function VinylMixResumeVoices(_mixName)
{
    static _mixDict = __VinylSystem().__mixDict;
    
    var _mixStruct = _mixDict[$ _mixName];
    if (_mixStruct == undefined) __VinylError("Mix \"", _mixName, "\" not recognised");
    
    _mixStruct.__ResumeVoices();
}