// Feather disable all

/// @param patternName
/// @param gain
/// @param pitch
/// @param loop
/// @param mix
/// @param ducker
/// @param duckPriority
/// @param metadata

function __VinylClassPatternAbstract(_patternName, _gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _metadata) constructor
{
    static _mixDict       = __VinylSystem().__mixDict;
    static _duckerDict    = __VinylSystem().__duckerDict;
    static _toUpdateArray = __VinylSystem().__toUpdateArray;
    
    __patternName = _patternName;
    __gain        = _gain;
    __pitch       = _pitch;
    __loop        = _loop;
    __mixName     = _mixName;
    __duckerName  = _duckerName;
    __duckPrio    = _duckPrio;
    __metadata    = _metadata;
    
    
    
    
    
    static __Play = function(_emitter_UNUSED, _loopLocal, _gainLocal, _pitchLocal, _duckerNameLocal, _duckPrioLocal)
    {
        return (new __VinylClassVoiceAbstract(self, _loopLocal, _gainLocal, _pitchLocal, _duckerNameLocal, _duckPrioLocal)).__voiceReference;
    }
    
    static __IsSoundPlaying = function()
    {
        return false;
    }
    
    static __UpdateSetup = function(_gain, _pitch, _loop, _mixName, _duckerName, _duckPrio, _metadata)
    {
        if (VINYL_LIVE_EDIT)
        {
            array_push(_toUpdateArray, self);
        }
        
        __gain       = _gain;
        __pitch      = _pitch;
        __loop       = _loop;
        __mixName    = _mixName;
        __duckerName = _duckerName;
        __duckPrio   = _duckPrio;
        __metadata   = _metadata;
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1, 1, false, (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX, undefined, 0, undefined);
    }
    
    static __ExportJSON = function(_ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gain == 1) && (__pitch == 1) && (not __loop))
            {
                return undefined;
            }
        }
        
        var _struct = {
            abstract: __patternName,
        };
        
        if (__gain != 1) _struct.gain = __gain;
        if (__pitch != 1) _struct.pitch = __pitch;
        if (__loop) _struct.loop = true;
        if (__duckerName != undefined) _struct.duckOn = __duckerName;
        if (__duckPrio != 0) _struct.duckPrio = __duckPrio;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gain == 1) && (__pitch == 1) && (not __loop))
            {
                return undefined;
            }
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    abstract: \"");
        buffer_write(_buffer, buffer_text, __patternName);
        buffer_write(_buffer, buffer_text, "\",\n");
        
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
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportAbstractJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "abstract":
                case "loop":
                case "gain":
                case "pitch":
                case "duckOn":
                case "duckPrio":
                case "metadata":
                break;
                
                default:
                    __VinylError("Abstract pattern \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupSound(_json.abstract, _json[$ "gain"], _json[$ "pitch"], _json[$ "loop"], undefined, _json[$ "duckOn"], _json[$ "duckPrio"], _json[$ "metadata"]);
    
    return _json.abstract;
}