// Feather disable all

/// @param patternName
/// @param soundArray
/// @param loop
/// @param gain
/// @param mix

function __VinylClassPatternBlend(_patternName, _soundArray, _loop, _gain, _mix) constructor
{
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    
    __patternName = _patternName;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __loop       = _loop;
    __gain       = _gain;
    
    __SetMix(_mix);
    
    static __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceBlend(self, _gainLocal, _pitchLocal);
        return _struct.__voiceTop;
    }
    
    static __UpdateSetup = function(_soundArray, _loop, _gain, _mix)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __loop       = _loop;
        __gain       = _gain;
        
        __SetMix(_mix);
        
        if (VINYL_LIVE_EDIT)
        {
            var _i = 0;
            repeat(array_length(_voiceCleanUpArray))
            {
                var _voiceStruct = _voiceCleanUpArray[_i];
                if (_voiceStruct.__pattern == self)
                {
                    _voiceStruct.__SetFromPattern(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix);
                }
                
                ++_i;
            }
        }
    }
    
    static __SetMix = function(_mix)
    {
        __mixName = _mix;
        __noMix   = (_mix == undefined) || (_mix == VINYL_NO_MIX);
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(__soundArray, 1, VINYL_DEFAULT_MIX);
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