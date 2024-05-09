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
    static _mixDict = __VinylSystem().__mixDict;
    
    __sound    = _sound;
    __gainMin  = _gainMin;
    __gainMax  = _gainMax;
    __pitchMin = _pitchMin;
    __pitchMax = _pitchMax;
    __loop     = _loop;
    __mix      = _mix;
    __noMix    = (_mix == VINYL_NO_MIX);
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _gainFactor  = __VinylRandom(1);
        var _pitchFactor = __VinylRandom(1);
        
        var _gainBase  = lerp(__gainMin,  __gainMax,  _gainFactor);
        var _pitchBase = lerp(__pitchMin, __pitchMax, _pitchFactor);
        
        var _gainMix = 1; //TODO
        
        var _voice = audio_play_sound(__sound, 0, _loop ?? __loop, _gainBase*_gainLocal*_gainMix, 0, _pitchBase*_pitchLocal);
        if (not __noMix)
        {
            var _mixStruct = _mixDict[$ __mix];
            if (_mixStruct == undefined)
            {
                __VinylError("Mix \"", __mix, "\" not recognised");
            }
            else
            {
                _mixStruct.__Add(_voice);
            }
        }
        
        if (VINYL_LIVE_EDIT) __VinylCreateSoundVoice(_voice, _gainBase, _gainLocal, _gainMix, _pitchBase, _pitchLocal, self, _gainFactor, _pitchFactor);
        return _voice;
    }
    
    static __UpdateSetup = function(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix)
    {
        static _voiceContextArray = __VinylSystem().__voiceStructArray;
        
        __gainMin  = _gainMin;
        __gainMax  = _gainMax;
        __pitchMin = _pitchMin;
        __pitchMax = _pitchMax;
        __loop     = _loop;
        
        var _i = 0;
        repeat(array_length(_voiceContextArray))
        {
            var _voiceStruct = _voiceContextArray[_i];
            if (_voiceStruct.__pattern == self)
            {
                var _voice = _voiceStruct.__voice;
                
                _voiceStruct.__loop = _loop;
                audio_sound_loop(_voice, _loop);
                
                var _gainBase  = lerp(_gainMin, _gainMax, _voiceStruct.__gainFactor);
                var _pitchBase = lerp(_pitchMin, _pitchMax, _voiceStruct.__pitchFactor);
                
                __UpdateSetup(_gainBase, _pitchBase);
            }
            
            ++_i;
        }
        
        __SetMix(_mix);
    }
    
    static __SetMix = function(_mix)
    {
        __mix   = _mix;
        __noMix = (_mix != VINYL_NO_MIX);
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

function __VinylImportSound(_json)
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
                case "mix":
                break;
                
                default:
                    __VinylError("Sound \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupSound(_json.sound, _json[$ "gain"], _json[$ "pitch"], _json[$ "loop"], _json[$ "mix"]);
}