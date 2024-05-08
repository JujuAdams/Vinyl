// Feather disable all

/// @param patternName
/// @param soundArray
/// @param gainMin
/// @param gainMax
/// @param pitchMin
/// @param pitchMax

function __VinylClassPatternShuffle(_patternName, _soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax) constructor
{
    __patternName = _patternName;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gainMin    = _gainMin;
    __gainMax    = _gainMax;
    __pitchMin   = _pitchMin;
    __pitchMax   = _pitchMax;
    
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
        
        var _gainPattern  = lerp(__gainMin,  __gainMax, _gainFactor);
        var _pitchPattern = lerp(__pitchMin, __pitchMax, _pitchFactor);
        
        var _voice = audio_play_sound(_sound, 0, false, _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);
        __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainFactor, _pitchFactor, __patternName);
        return _voice;
    }
    
    static __Update = function(_soundArray, _gainMin, _gainMax, _pitchMin, _pitchMax)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gainMin    = _gainMin;
        __gainMax    = _gainMax;
        __pitchMin   = _pitchMin;
        __pitchMax   = _pitchMax;
        
        __soundCount = array_length(__soundArray);
        __playIndex  = infinity;
    }
    
    static __ExportJSON = function()
    {
        var _struct = {};
        return _struct;
    }
}

function __VinylJSONImportShuffle(_json)
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
                break;
                
                default:
                    __VinylError("Shuffle pattern property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "sounds")) __VinylError("Shuffle pattern \"", _json.shuffle, "\" property .sounds must be defined");
    }
    
    VinylSetupShuffle(_json.shuffle, _json.sounds, _json[$ "gain"], _json[$ "pitch"]);
}