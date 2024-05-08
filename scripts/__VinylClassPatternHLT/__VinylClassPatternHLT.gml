// Feather disable all

/// @param patternName
/// @param soundHead
/// @param soundLoop
/// @param soundTail
/// @param gain
/// @param mix

function __VinylClassPatternHLT(_patternName, _soundHead, _soundLoop, _soundTail, _gain, _mix) constructor
{
    __patternName = _patternName;
    
    __soundHead = __VinylImportSound(_soundHead);
    __soundLoop = __VinylImportSound(_soundLoop);
    __soundTail = __VinylImportSound(_soundTail);
    __gain      = _gain;
    __mix       = _mix;
    
    //Don't make this static!
    __Play = function(_loop, _gainLocal, _pitchLocal)
    {
        var _struct = new __VinylClassVoiceHLT(self, _gainLocal, _pitchLocal);
        return _struct.__currentVoice;
    }
    
    static __Update = function(_soundHead, _soundLoop, _soundTail, _gain, _mix)
    {
        __soundHead = __VinylImportSound(_soundHead);
        __soundLoop = __VinylImportSound(_soundLoop);
        __soundTail = __VinylImportSound(_soundTail);
        __gain      = _gain;
        
        //TODO - Change tracks over for extant currently-playing HLT voices
        
        __SetMix(_mix);
    }
    
    static __SetMix = function(_mix)
    {
        __mix = _mix;
    }
    
    static __Clear = function()
    {
        __Update(__soundHead, __soundLoop, __soundTail, 1, VINYL_DEFAULT_MIX);
    }
    
    static __ExportJSON = function()
    {
        var _struct = {};
        return _struct;
    }
}

function __VinylJSONImportHLT(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "hlt":
                case "head":
                case "loop":
                case "tail":
                case "gain":
                case "mix":
                break;
                
                default:
                    __VinylError("Head-Loop-Tail pattern property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
        
        if (not struct_exists(_json, "loop")) __VinylError("Head-Loop-Tail pattern \"", _json.hlt, "\" property .loop must be defined");
    }
    
    VinylSetupHLT(_json.hlt, _json[$ "head"], _json.loop, _json[$ "tail"], _json[$ "gain"], _json[$ "mix"]);
}