// Feather disable all

/// @param mixName
/// @param baseGain

function __VinylClassMix(_mixName, _gainBase) constructor
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    __mixName  = _mixName;
    __gainBase = _gainBase;
    
    __gainLocal = 1;
    __gainFinal = _gainBase;
    
    __voiceIndex = 0;
    __voiceArray = [];
    
    static __Update = function()
    {
        var _array = __voiceArray;
        var _length = array_length(_array);
        if (_length > 0)
        {
            var _index = (__voiceIndex + 1) mod _length;
            if (not audio_is_playing(_array[_index])) array_delete(_array, _index, 1);
            __voiceIndex = _index;
        }
    }
    
    static __UpdateSetup = function(_gainBase)
    {
        __gainBase = _gainBase;
        __UpdateMemberGain();
    }
    
    static __UpdateMemberGain = function()
    {
        var _gainFinal = __gainBase*_gain;
        __gainFinal = _gainFinal;
        
        var _array = __voiceArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            __VinylEnsureSoundVoice(_array[_i]).__SetMixGain(_gainFinal);
            ++_i;
        }
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(1);
    }
    
    static __Add = function(_voice)
    {
        array_push(__voiceArray, _voice);
    }
    
    static __StopVoices = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylStop(__voiceArray[_i]);
            ++_i;
        }
    }
    
    static __FadeOutVoices = function(_rateOfChange)
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            VinylFadeOut(__voiceArray[_i], _rateOfChange);
            ++_i;
        }
    }
    
    static __SetGain = function(_gain)
    {
        __gainLocal = _gain;
        __UpdateMemberGain();
    }
    
    static __ExportJSON = function()
    {
        var _struct = {
            mix:      __mixName,
            baseGain: __gainBase,
        };
        
        return _struct;
    }
}

function __VinylImportMixGroup(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "mix":
                case "baseGain":
                case "members":
                break;
                
                default:
                    __VinylError("Mix property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupMix(_json.mix, _json[$ "baseGain"]);
    
    var _membersArray = _json[$ "members"];
    if (is_array(_membersArray))
    {
        var _i = 0;
        repeat(array_length(_membersArray))
        {
            var _memberData = _membersArray[_i];
            
            var _return = VinylSetupImport(_memberData);
            if (_return != undefined) VinylSetMixForAssets(_json.mix, _return);
            
            ++_i;
        }
    }
    
    return _json.mix;
}