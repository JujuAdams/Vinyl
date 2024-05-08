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
    __mix        = _mix;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceBlend(self, _gainLocal, _pitchLocal);
        return _struct.__voiceTop;
    }
    
    static __Update = function(_soundArray, _gain, _mix)
    {
        __soundArray = __VinylImportSoundArray(_soundArray);
        __gain       = _gain;
        
        //TODO - Change tracks over for extant currently-playing blend voices
        
        __SetMix(_mix);
    }
    
    static __SetMix = function(_mix)
    {
        __mix = _mix;
    }
    
    static __Clear = function()
    {
        __Update(__soundArray, 1, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
        var _struct = {};
        return _struct;
    }
}

function __VinylJSONImportBlend(_json)
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
                case "mix":
                break;
                
                default:
                    __VinylError("Blend pattern property \"", _variableNames[_i], "\" not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "sounds")) __VinylError("Blend pattern \"", _json.blend, "\" property .sounds must be defined");
    }
    
    VinylSetupBlend(_json.blend, _json.sounds, _json[$ "gain"], _json[$ "mix"]);
}