// Feather disable all

/// @param metadataName
/// @param data

function VinylSetupMetadata(_metadata, _data)
{
    static _metadataDict = __VinylSystem().__metadataDict;
    
    _metadataDict[$ _metadata] = _data;
}

function __VinylImportMetadataJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "metadata":
                case "data":
                break;
                
                default:
                    __VinylError("Metadata property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "data")) __VinylError("Metadata pattern \"", _json.metadata, "\" property .data must be defined");
    }
    
    VinylSetupMetadata(_json.metadata, _json.data);
    
    return _json.metadata;
}