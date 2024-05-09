// Feather disable all

/// @param patternName
/// @param soundArray
/// @param gainMin
/// @param gainMax
/// @param pitchMin
/// @param pitchMax
/// @param mix

function __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix) constructor
{
    __patternName = _patternName;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gainMin    = _gainMin;
    __gainMax    = _gainMax;
    __pitchMin   = _pitchMin;
    __pitchMax   = _pitchMax;
    __mix        = _mix;
    
    __soundCount = array_length(__soundArray);
    __playIndex  = infinity;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        if (__playIndex >= __soundCount) //If we've played through our bank of sounds, reshuffle
        {
            __playIndex = 0;
            var _last = __soundArray[__soundCount-1];
            array_delete(__soundArray, __soundCount-1, 1); //Make sure we don't reshuffle in the last played sound...
            __VinylArrayShuffle(__soundArray);
            array_insert(__soundArray, __soundCount div 2, _last); //...and stick it somewhere in the middle instead
        }
        
        var _sound = __soundArray[__playIndex];
        ++__playIndex;
        
        var _gainFactor  = __VinylRandom(1);
        var _pitchFactor = __VinylRandom(1);
        
        var _gainBase  = lerp(__gainMin,  __gainMax,  _gainFactor);
        var _pitchBase = lerp(__pitchMin, __pitchMax, _pitchFactor);
        
        var _gainMix = 1; //TODO
        
        var _voice = audio_play_sound(_sound, 0, _loop ?? __loop, _gainBase*_gainLocal*_gainMix, 0, _pitchBase*_pitchLocal);
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
    
    static __UpdateSetup = function(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax, _mix)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gainMin    = _gainMin;
        __gainMax    = _gainMax;
        __pitchMin   = _pitchMin;
        __pitchMax   = _pitchMax;
        
        __soundCount = array_length(__soundArray);
        __playIndex  = infinity;
        
        __SetMix(_mix);
    }
    
    static __SetMix = function(_mix)
    {
        __mix = _mix;
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(__soundArray, 1, 1, 1, 1, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
        var _struct = {};
        return _struct;
    }
}

function __VinylImportShuffle(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "shuffle":
                case "sounds":
                case "gain":
                case "pitch":
                case "mix":
                break;
                
                default:
                    __VinylError("Shuffle pattern property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "sounds")) __VinylError("Shuffle pattern \"", _json.shuffle, "\" property .sounds must be defined");
    }
    
    VinylSetupShuffle(_json.shuffle, _json.sounds, _json[$ "gain"], _json[$ "pitch"], _json[$ "mix"]);
}