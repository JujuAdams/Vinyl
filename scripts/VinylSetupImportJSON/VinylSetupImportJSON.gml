// Feather disable all

/// Imports a JSON that contains definitions for mixes, sounds, and patterns. This is sometimes
/// more convenient than writing lines of code.
/// 
/// You can read more about the JSON format that Vinyl expects in the "Vinyl Setup JSON Format"
/// note asset included with the library code.
/// 
/// @param json
/// @param [overwrite=true]

function VinylSetupImportJSON(_json, _overwrite = true)
{
    static _system            = __VinylSystem();
    static _toUpdateArray     = _system.__toUpdateArray;
    static _voiceCleanUpArray = _system.__voiceCleanUpArray;
    static _voiceUpdateArray  = _system.__voiceUpdateArray;
    
    if (VINYL_LIVE_EDIT)
    {
        _system.__importingJSON = true;
    }
    
    var _result = __VinylSetupImportJSONInner(_json, _overwrite);
    
    if (VINYL_LIVE_EDIT)
    {
        _system.__importingJSON = false;
        __VinylResolveChanges();
    }
    
    return _result;
}

function __VinylSetupImportJSONInner(_json, _overwrite)
{
    //TODO - Implement overwrite behaviour
    
    if (is_array(_json))
    {
        var _i = 0;
        repeat(array_length(_json))
        {
            __VinylSetupImportJSONInner(_json[_i], _overwrite);
            ++_i;
        }
    }
    else if (is_struct(_json))
    {
        if (struct_exists(_json, "shuffle"))
        {
            return __VinylImportShuffleJSON(_json);
        }
        else if (struct_exists(_json, "hlt"))
        {
            return __VinylImportHLTJSON(_json);
        }
        else if (struct_exists(_json, "blend"))
        {
            return __VinylImportBlendJSON(_json);
        }
        else if (struct_exists(_json, "sound"))
        {
            return __VinylImportSoundJSON(_json);
        }
        else if (struct_exists(_json, "mix"))
        {
            return __VinylImportMixGroupJSON(_json, _overwrite);
        }
        else if (struct_exists(_json, "metadata"))
        {
            return __VinylImportMetadataJSON(_json);
        }
        else
        {
            __VinylError("Struct could not be parsed, missing type information\nStruct should contain one of the following variables to indicate type:\n  .sound\n  .shuffle\n  .hlt\n  .blend\n  .mix");
        }
    }
    else
    {
        __VinylError("Datatype unsupported (", typeof(_json), ")");
    }
    
    return undefined;
}