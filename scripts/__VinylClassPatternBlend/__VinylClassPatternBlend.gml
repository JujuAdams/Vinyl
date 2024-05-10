// Feather disable all

/// @param patternName
/// @param soundArray
/// @param gain
/// @param mix

function __VinylClassPatternBlend(_patternName, _soundArray, _gain, _mix) constructor
{
    __patternName = _patternName;
    
    __soundArray = __VinylImportSoundArray(_soundArray);
    __gain       = _gain;
    
    __SetMix(_mix);
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceBlend(self, _gainLocal, _pitchLocal);
        return _struct.__voiceTop;
    }
    
    static __UpdateSetup = function(_soundArray, _gain, _mix)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gain       = _gain;
        
        __SetMix(_mix);
        
        if (VINYL_LIVE_EDIT)
        {
            //TODO
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
        var _struct = {};
        return _struct;
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
                case "type":
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
    
    VinylSetupBlend(_json.blend, _json.sounds, _json[$ "gain"]);
    
    return _json.blend;
}