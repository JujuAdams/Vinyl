// Feather disable all

/// @param sound
/// @param gain
/// @param pitch
/// @param loop
/// @param mix

function __VinylClassPatternSound(_sound, _gain, _pitch, _loop, _mix) constructor
{
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _mixDict           = __VinylSystem().__mixDict;
    
    __sound = _sound;
    __gain  = _gain;
    __pitch = _pitch;
    __loop  = _loop;
    
    __SetMix(_mix);
    
    static __Play = function(_loopLocal, _gainLocal, _pitchLocal)
    {
        var _gainBase  = __gain;
        var _pitchBase = __pitch;
        var _loopFinal = _loopLocal ?? __loop;
        
        if (__noMix)
        {
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal/VINYL_MAX_VOICE_GAIN, 0, _pitchBase*_pitchLocal);
            var _gainMix = 1;
        }
        else
        {
            var _mixStruct = _mixDict[$ __mixName];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", __mixName, "\" not recognised");
                return;
            }
            
            var _gainMix = _mixStruct.__gainFinal;
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal*_gainMix/VINYL_MAX_VOICE_GAIN, 0, _pitchBase*_pitchLocal);
            _mixStruct.__Add(_voice);
        }
        
        //If we're in live edit mode then always create a struct representation
        if (VINYL_LIVE_EDIT)
        {
            new __VinylClassVoiceSound(_voice, _loopLocal, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, self);
        }
        
        return _voice;
    }
    
    static __UpdateSetup = function(_gain, _pitch, _loop, _mix)
    {
        __gain  = _gain;
        __pitch = _pitch;
        __loop  = _loop;
        
        __SetMix(_mix);
        
        if (VINYL_LIVE_EDIT)
        {
            var _i = 0;
            repeat(array_length(_voiceCleanUpArray))
            {
                var _voiceStruct = _voiceCleanUpArray[_i];
                if (_voiceStruct.__pattern == self)
                {
                    _voiceStruct.__SetFromPattern(_gain, _pitch, _loop, _mix);
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
        __UpdateSetup(1, 1, false, VINYL_DEFAULT_MIX);
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
            sound: audio_get_name(__sound),
        };
        
        if (__gain != 1) _struct.gain = __gain;
        if (__pitch != 1) _struct.pitch = __pitch;
        if (__loop) _struct.loop = true;
        
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
        buffer_write(_buffer, buffer_text, "    sound: ");
        buffer_write(_buffer, buffer_text, audio_get_name(__sound));
        buffer_write(_buffer, buffer_text, ",\n");
        
        if (__gain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    gain: ");
            buffer_write(_buffer, buffer_text, __gain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__pitch == 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    pitch: ");
            buffer_write(_buffer, buffer_text, __pitch);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__loop)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    loop: true,\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportSoundJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "sound":
                case "loop":
                case "gain":
                case "pitch":
                break;
                
                default:
                    __VinylError("Sound \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    var _sound = _json.sound;
    if (is_string(_sound))
    {
        var _handle = asset_get_index(_sound);
        if (not audio_exists(_handle))
        {
            __VinylTrace("Warning! Sound with name \"", _sound, "\" not found");
            return;
        }
    }
    else if (not is_handle(_sound))
    {
        __VinylError("Sound specified with incorrect datatype (", typeof(_sound), ")");
    }
    
    VinylSetupSound(_json.sound, _json[$ "gain"], _json[$ "pitch"], _json[$ "loop"]);
    
    return _json.sound;
}