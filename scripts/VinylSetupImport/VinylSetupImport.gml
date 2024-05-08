// Feather disable all

/// @param json

function VinylSetupImport(_json)
{
    if (is_array(_json))
    {
        var _i = 0;
        repeat(array_length(_json))
        {
            VinylSetupImport(_json[_i]);
            ++_i;
        }
    }
    else if (is_struct(_json))
    {
        if (struct_exists(_json, "shuffle"))
        {
            __VinylJSONImportShuffle(_json);
        }
        else if (struct_exists(_json, "hlt"))
        {
            __VinylJSONImportHLT(_json);
        }
        else if (struct_exists(_json, "blend"))
        {
            __VinylJSONImportBlend(_json);
        }
        else if (struct_exists(_json, "sound"))
        {
            __VinylJSONImportSound(_json);
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
}