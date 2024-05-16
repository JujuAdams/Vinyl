// Feather disable all

/// @param patternName
/// @param soundArray
/// @param loop
/// @param gain
/// @param mix

function __VinylClassPatternBlend(_patternName, _soundArray, _loop, _gain, _mixName) constructor
{
    static _soundDict     = __VinylSystem().__soundDict;
    static _toUpdateArray = __VinylSystem().__toUpdateArray;
    
    
    __patternName = _patternName;
    
    __soundArray     = __VinylImportSoundArray(_soundArray);
    __soundGainArray = array_create(array_length(__soundArray), 1);
    __loop           = _loop;
    __gain           = _gain;
    __mixName        = _mixName;
    
    __UpdateSoundGains();
    
    
    
    
    
    static __Play = function(_loopLocal, _gainLocal, _pitchLocal)
    {
        return (new __VinylClassVoiceBlend(self, _loopLocal, _gainLocal, _pitchLocal, __mixName)).__voiceReference;
    }
    
    static __UpdateSetup = function(_soundArray, _loop, _gain, _mixName)
    {
        if (VINYL_LIVE_EDIT)
        {
            __changedSoundArray = (not array_equals(__soundArray, _soundArray));
            array_push(_toUpdateArray, self);
        }
        
        __soundArray = __VinylImportSoundArray(_soundArray);
        __loop       = _loop;
        __gain       = _gain;
        __mixName    = _mixName;
        
        __UpdateSoundGains();
    }
    
    static __UpdateSoundGains = function()
    {
        //FIXME - This can be invalidated if sound gains change after this method is called
        
        var _soundArray = __soundArray;
        var _gainArray  = __soundGainArray;
        array_resize(_gainArray, array_length(_soundArray));
        
        var _i = 0;
        repeat(array_length(_soundArray))
        {
            _gainArray[_i] = struct_get_from_hash(_soundDict, int64(_soundArray[_i])).__gain;
            ++_i;
        }
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(__soundArray, false, 1, (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX);
    }
    
    static __UsesSound = function(_sound)
    {
        return array_contains(__soundArray, _sound);
    }
    
    static __ExportJSON = function()
    {
        var _soundArray = [];
        var _i = 0;
        repeat(array_length(__soundArray))
        {
            array_push(_soundArray, audio_get_name(__soundArray[_i]));
            ++_i;
        }
        
        var _struct = {
            blend: __patternName,
            sounds: _soundArray,
        };
        
        if (not __loop) _struct.loop = false;
        if (__gain != 1) _struct.gain = __gain;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _useMacros)
    {
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    blend: ");
        
        if (_useMacros)
        {
            buffer_write(_buffer, buffer_text, __VinylGetPatternMacro(__patternName));
            buffer_write(_buffer, buffer_text, ",\n");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "\"");
            buffer_write(_buffer, buffer_text, __patternName);
            buffer_write(_buffer, buffer_text, "\",\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    sounds: [");
        
        if (array_length(__soundArray) > 0)
        {
            var _i = 0;
            repeat(array_length(__soundArray))
            {
                buffer_write(_buffer, buffer_text, audio_get_name(__soundArray[_i]));
                buffer_write(_buffer, buffer_text, ", ");
                ++_i;
            }
            
            buffer_seek(_buffer, buffer_seek_relative, -2);
        }
        
        buffer_write(_buffer, buffer_text, "],\n");
        
        if (not __loop)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    loop: false,\n");
        }
        
        if (__gain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    gain: ");
            buffer_write(_buffer, buffer_text, __gain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportBlendJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "blend":
                case "loop":
                case "sounds":
                case "gain":
                break;
                
                default:
                    __VinylError("Blend pattern property \"", _variableNames[_i], "\" not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "sounds")) __VinylError("Blend pattern \"", _json.blend, "\" property .sounds must be defined");
    }
    
    VinylSetupBlend(_json.blend, _json.sounds, _json[$ "loop"], _json[$ "gain"]);
    
    return _json.blend;
}