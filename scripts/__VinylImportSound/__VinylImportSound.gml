// Feather disable all

/// @param sound
/// @param [strict=true]

function __VinylImportSound(_sound, _strict = true)
{
    static _patternMap = __VinylSystem().__patternMap;
    
    if (is_string(_sound))
    {
        var _newSound = asset_get_index(_sound);
        
        if (not audio_exists(_newSound))
        {
            var _existingPattern = _patternMap[? _sound];
            
            if (is_instanceof(_existingPattern, __VinylClassPatternExternalWAV)
            ||  is_instanceof(_existingPattern, __VinylClassPatternExternalOGG))
            {
                _newSound = _existingPattern.__sound;
            }
            else
            {
                if (_strict) __VinylError("Sound \"", _sound, "\" not found or this external sound hasn't been loaded");
            }
        }
        
        return _newSound;
    }
    else if ((_sound == undefined) || (_sound == pointer_null))
    {
        return undefined;
    }
    else if (is_handle(_sound))
    {
        return _sound;
    }
    
    if (_strict) __VinylError("Datatype not supported (", typeof(_sound), ")");
}