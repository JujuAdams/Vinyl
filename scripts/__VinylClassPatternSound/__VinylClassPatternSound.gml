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
    static _voiceStructArray = __VinylSystem().__voiceStructArray;
    static _mixDict          = __VinylSystem().__mixDict;
    
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
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _loopFinal = _loop ?? __loop;
        
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
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal, 0, _pitchBase*_pitchLocal);
            var _gainMix = 1; //TODO
        }
        else
        {
            var _mixStruct = _mixDict[$ __mix];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", __mix, "\" not recognised");
                return;
            }
            
            var _gainMix = _mixStruct.__gainFinal;
            var _voice = audio_play_sound(__sound, 0, _loopFinal, _gainBase*_gainLocal*_gainMix, 0, _pitchBase*_pitchLocal);
            _mixStruct.__Add(_voice);
        }
        
        if (_loopFinal || VINYL_LIVE_EDIT) __VinylCreateSoundVoice(_voice, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, self, _gainFactor, _pitchFactor);
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
            //TODO
        }
    }
    
    static __SetMix = function(_mix)
    {
        __mix   = _mix;
        __noMix = (_mix == undefined) || (_mix == VINYL_NO_MIX);
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1, 1, 1, 1, false, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
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