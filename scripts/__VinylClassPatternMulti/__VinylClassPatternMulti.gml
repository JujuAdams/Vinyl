/// @param name
/// @param adHoc

function __VinylClassPatternMulti(_name, _adHoc) : __VinylClassPatternCommon() constructor
{
    static __patternType = "multi";
    static __pool = __VinylGlobalData().__poolMulti;
    
    __name  = _name;
    __adHoc = _adHoc;
    
    static toString = function()
    {
        return "<multi " + string(__name) + ">";
    }
    
    static __Initialize = function(_patternData = {}, _labelDict, _knobDict)
    {
        if (VINYL_CONFIG_VALIDATE_PATTERNS) __ValidateStruct(_patternData, ["type", "asset", "assets", "gain", "pitch", "effect chain", "label", "labels", "blend", "sync"]);
        
        //Set the gain/pitch state from the provided struct
        var _assetArray      = _patternData[$ "assets"      ] ?? (_patternData[$ "asset"] ?? []);
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _effectChainName = _patternData[$ "effect chain"];
        var _labelNameArray  = _patternData[$ "label"       ] ?? _patternData[$ "labels"];
        var _blend           = _patternData[$ "blend"       ] ?? undefined;
        var _sync            = _patternData[$ "sync"        ] ?? false;
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        __InitializeAssetArray(_assetArray);
        __InitializeGain(_gain, _knobDict);
        __InitializePitch(_pitch, _knobDict);
        __InitializeEffectChain(_effectChainName);
        __InitializeLabelArray(_labelNameArray, _labelDict);
        
        //Set the blend state
        if ((!is_undefined(_blend) && !is_numeric(_blend))
        ||  (is_numeric(_blend) && ((_blend < 0) || (_blend > 1))))
        {
            __VinylError("Error in pattern ", self, "\nBlend must be a number between 0 and 1 (inclusive)");
        }
        
        __blend = _blend;
        
        //Set the sync state
        if (!is_bool(_sync))
        {
            __VinylError("Error in pattern ", self, "\nSync must be a boolean (<true> or <false>)");
        }
        
        __sync = _sync;
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(_labelArray));
    }
    
    static __Play = function(_parentInstance, _emitter, _sound, _loop = false, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _instance = __pool.__Depool();
        _instance.__Instantiate(self, _parentInstance, _emitter, __assetArray, _loop, _gain, _pitch, _pan, __blend,  __sync);
        return _instance;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1)
    {
        __VinylError("Cannot use VinylPlaySimple() with a multi pattern");
    }
}