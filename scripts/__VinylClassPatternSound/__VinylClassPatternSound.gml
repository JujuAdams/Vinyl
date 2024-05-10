// Feather disable all

/// @param sound
/// @param gainMin
/// @param gainMax
/// @param pitchMin
/// @param pitchMax
/// @param loop
/// @param mix

function __VinylClassPatternSound(_sound, _gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix) constructor
{
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceStructDict   = __VinylSystem().__voiceStructDict;
    static _mixDict           = __VinylSystem().__mixDict;
    
    __sound    = _sound;
    __gainMin  = _gainMin;
    __gainMax  = _gainMax;
    __pitchMin = _pitchMin;
    __pitchMax = _pitchMax;
    __loop     = _loop;
    
    __gainRandomize  = (_gainMin != _gainMax);
    __pitchRandomize = (_pitchMin != _pitchMax);
    
    __SetMix(_mix);
    
    //Don't make this static!
    __Play = function(_loopLocal, _gainLocal, _pitchLocal)
    {
        var _loopFinal = _loopLocal ?? __loop;
        
        if (__gainRandomize)
        {
            var _gainFactor = __VinylRandom(1);
            var _gainBase   = lerp(__gainMin,  __gainMax,  _gainFactor);
        }
        else
        {
            var _gainFactor = 0.5;
            var _gainBase   = __gainMin;
        }
        
        if (__pitchRandomize)
        {
            var _pitchFactor = __VinylRandom(1);
            var _pitchBase   = lerp(__pitchMin, __pitchMax, _pitchFactor);
        }
        else
        {
            var _pitchFactor = 0.5;
            var _pitchBase   = __pitchMin;
        }
        
        if (__noMix)
        {
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal/VINYL_MAX_GAIN, 0, _pitchBase*_pitchLocal);
            var _gainMix = 1; //TODO
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
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal*_gainMix/VINYL_MAX_GAIN, 0, _pitchBase*_pitchLocal);
            _mixStruct.__Add(_voice);
        }
        
        //If we're in live edit mode then always create a struct representation
        if (VINYL_LIVE_EDIT)
        {
            new __VinylClassVoiceSound(_voice, _loopLocal, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, self, _gainFactor, _pitchFactor);
        }
        
        return _voice;
    }
    
    static __UpdateSetup = function(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix)
    {
        __gainMin  = _gainMin;
        __gainMax  = _gainMax;
        __pitchMin = _pitchMin;
        __pitchMax = _pitchMax;
        __loop     = _loop;
        
        __gainRandomize  = (_gainMin != _gainMax);
        __pitchRandomize = (_pitchMin != _pitchMax);
        
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
        __UpdateSetup(1, 1, 1, 1, false, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function(_ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gainMin == 1) && (__gainMax == 1)
            &&  (__pitchMin == 1) && (__pitchMax == 1)
            &&  (not __loop))
            {
                return undefined;
            }
        }
        
        var _struct = {
            sound: audio_get_name(__sound),
        };
        
        if ((__gainMin != 1) || (__gainMax != 1))
        {
            if (__gainMin == __gainMax)
            {
                _struct.gain = __gainMin;
            }
            else
            {
                _struct.gain = [__gainMin, __gainMax];
            }
        }
        
        if ((__pitchMin != 1) || (__pitchMax != 1))
        {
            if (__pitchMin == __pitchMax)
            {
                _struct.pitch = __pitchMin;
            }
            else
            {
                _struct.pitch = [__pitchMin, __pitchMax];
            }
        }
        
        if (__loop)
        {
            _struct.loop = true;
        }
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent, _ignoreEmpty)
    {
        if (_ignoreEmpty)
        {
            if ((__gainMin == 1) && (__gainMax == 1)
            &&  (__pitchMin == 1) && (__pitchMax == 1)
            &&  (not __loop))
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
        
        if ((__gainMin != 1) || (__gainMax != 1))
        {
            if (__gainMin == __gainMax)
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    gain: ");
                buffer_write(_buffer, buffer_text, __gainMin);
                buffer_write(_buffer, buffer_text, ",\n");
            }
            else
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    gain: [");
                buffer_write(_buffer, buffer_text, __gainMin);
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, __gainMax);
                buffer_write(_buffer, buffer_text, "],\n");
            }
        }
        
        if ((__pitchMin != 1) || (__pitchMax != 1))
        {
            if (__pitchMin == __pitchMax)
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    pitch: ");
                buffer_write(_buffer, buffer_text, __pitchMin);
                buffer_write(_buffer, buffer_text, ",\n");
            }
            else
            {
                buffer_write(_buffer, buffer_text, _indent);
                buffer_write(_buffer, buffer_text, "    pitch: [");
                buffer_write(_buffer, buffer_text, __pitchMin);
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, __pitchMax);
                buffer_write(_buffer, buffer_text, "],\n");
            }
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