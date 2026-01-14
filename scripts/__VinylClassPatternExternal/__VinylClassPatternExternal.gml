// Feather disable all

/// @param path
/// @param patternName
/// @param sound
/// @param gain
/// @param pitch
/// @param loop
/// @param mix
/// @param ducker
/// @param duckPriority
/// @param emitterAlias
/// @param metadata

function __VinylClassPatternExternal(_path, _patternName, _sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) : __VinylClassPatternSound(_sound, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _emitterAlias, _metadata) constructor
{
    static _patternDict = __VinylSystem().__patternDict;
    static _soundMap    = __VinylSystem().__soundMap;
    
    __path         = _path;
    __patternName  = _patternName;
    
    
    
    static __GetPatternName = function()
    {
        return __patternName ?? __path;
    }
    
    static __FreeCommon = function()
    {
        //FIXME - What happens if you're using this sound in other patterns?
        
        audio_stop_sound(__sound);
        
        var _patternName = __GetPatternName();
        var _existingPattern = _patternDict[$ _patternName];
        if (_existingPattern == self)
        {
            variable_struct_remove(_patternDict, _patternName);
        }
        
        var _existingPattern = _soundMap[? int64(__sound)];
        if (_existingPattern == self)
        {
            ds_map_delete(_soundMap, int64(__sound));
        }
    }
    
    static __ExportJSON = function(_ignoreEmpty_UNUSED)
    {
        var _struct = {
            external: __path,
        };
        
        if (__patternName != undefined) _struct.alias = __patternName;
        if (__gain != 1) _struct.gain = __gain;
        if (__pitch != 1) _struct.pitch = __pitch;
        if (__loop) _struct.loop = true;
        if (__duckerName != undefined) _struct.duckOn = __duckerName;
        if (__duckPrio != 0) _struct.duckPrio = __duckPrio;
        if (__emitterAlias != undefined) _struct.emitter = __emitterAlias;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _ignoreEmpty_UNUSED)
    {
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    external: ");
        buffer_write(_buffer, buffer_text, __path);
        buffer_write(_buffer, buffer_text, ",\n");
        
        if (__patternName != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    alias: ");
            buffer_write(_buffer, buffer_text, __patternName);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__gain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    gain: ");
            buffer_write(_buffer, buffer_text, __gain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__pitch != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    pitch: ");
            buffer_write(_buffer, buffer_text, __pitch);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__loop)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    loop: ");
            buffer_write(_buffer, buffer_text, __loop? "true" : "false");
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__duckerName != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    duckOn: \"");
            buffer_write(_buffer, buffer_text, __duckerName);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        if (__duckPrio != 0)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    duckPrio: ");
            buffer_write(_buffer, buffer_text, string(__duckPrio));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__emitterAlias != undefined)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    emitter: \"");
            buffer_write(_buffer, buffer_text, __emitterAlias);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportExternalJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "external":
                case "alias":
                case "loop":
                case "gain":
                case "pitch":
                case "duckOn":
                case "duckPrio":
                case "emitter":
                case "metadata":
                case "forceType":
                break;
                
                default:
                    __VinylError("External audio \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupExternal(_json.external, _json[$ "alias"], _json[$ "gain"], _json[$ "pitch"], _json[$ "loop"], undefined, _json[$ "duckOn"], _json[$ "duckPrio"], _json[$ "emitter"], _json[$ "metadata"], _json[$ "forceType"]);
    return _json.external;
}