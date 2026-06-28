// Feather disable all

/// Returns a pitch multiplier for a new BPM based on the base BPM of the voice or pattern.
///
/// @param voiceOrPattern
/// @param newBPM

function VinylGetPitchForBPM(_voiceOrPattern, _newBPM)
{
    static _patternMap = __VinylSystem().__patternMap;
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _oldBPM = undefined;
    if (is_handle(_voiceOrPattern))
    {
        _oldBPM = __VinylEnsurePatternSound(_voiceOrPattern).__bpm;
    }
    else if (is_string(_voiceOrPattern))
    {
        var _patternStruct = _patternMap[? _voiceOrPattern];
        if (_patternStruct != undefined)
        {
            _oldBPM = _patternStruct.__bpm;
        }
        else
        {
            __VinylError("Pattern \"", _voiceOrPattern, "\" not found");
        }
    }
    else
    {
        var _voiceStruct = _voiceToStructMap[? _voiceOrPattern];
        if (_voiceStruct != undefined)
        {
            _oldBPM = _voiceStruct.__GetBPM();
        }
        else
        {
            __VinylError("Datatype not supported (", typeof(_voiceOrPattern), ")");
        }
    }
    
    if (_oldBPM == undefined)
    {
        __VinylWarning("Voice / Pattern \"", _voiceOrPattern, "\" does not have a BPM associated with it");
        return 1;
    }
    else
    {
        return _newBPM / _oldBPM;
    }
}