// Feather disable all

/// @param json

function VinylSetupImportJSON(_json)
{
    if (is_array(_json))
    {
        var _i = 0;
        repeat(array_length(_json))
        {
            VinylSetupImportJSON(_json[_i]);
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
            return __VinylImportMixGroupJSON(_json);
        }
        else
        {
            __VinylError("Strict could not be parsed, missing type information\nStruct should contain one of the following variables to indicate type:\n  .sound\n  .shuffle\n  .hlt\n  .blend");
        }
    }
    else
    {
        __VinylError("Datatype unsupported (", typeof(_json), ")");
    }
    
    return undefined;
}