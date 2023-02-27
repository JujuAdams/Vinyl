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
    
    static __Initialize = function(_patternData = {})
    {
        var _knobDict = __VinylGlobalData().__knobDict;
        
        if (VINYL_CONFIG_VALIDATE_PROPERTIES) __VinylValidateStruct(_patternData, ["type", "asset", "assets", "gain", "pitch", "transpose", "loop", "stack", "stack priority", "persistent", "effect chain", "label", "labels", "blend", "blend normalize", "blend normalise", "sync"]);
        
        //Set the gain/pitch state from the provided struct
        var _assetArray      = _patternData[$ "assets"         ] ?? (_patternData[$ "asset"] ?? []);
        var _gain            = _patternData[$ "gain"           ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"          ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _transpose       = _patternData[$ "transpose"      ];
        var _loop            = _patternData[$ "loop"           ];
        var _persistent      = _patternData[$ "persistent"     ];
        var _stack           = _patternData[$ "stack"          ];
        var _stackPriority   = _patternData[$ "stack priority" ] ?? 0;
        var _effectChainName = _patternData[$ "effect chain"   ] ?? _patternData[$ "effect"];
        var _labelNameArray  = _patternData[$ "label"          ] ?? _patternData[$ "labels"];
        var _blend           = _patternData[$ "blend"          ] ?? VINYL_DEFAULT_MULTI_BLEND;
        var _blendNormalize  = _patternData[$ "blend normalize"] ?? (_patternData[$ "blend normalise"] ?? VINYL_DEFAULT_MULTI_BLEND_NORMALIZE);
        var _sync            = _patternData[$ "sync"           ] ?? VINYL_DEFAULT_MULTI_SYNC;
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        __InitializeAssetArray(_assetArray);
        __InitializeGain(_gain);
        __InitializePitch(_pitch);
        __InitializeTranspose(_transpose);
        __InitializeLoop(_loop);
        __InitializePersistent(_persistent);
        __InitializeStack(_stack, _stackPriority);
        __InitializeEffectChain(_effectChainName);
        __InitializeLabelArray(_labelNameArray);
        
        //Set the blend state
        if (is_string(_blend))
        {
            if (string_char_at(_blend, 1) == "@")
            {
                var _knobName = string_delete(_blend, 1, 1);
                var _knob = _knobDict[$ _knobName];
                if (!is_struct(_knob)) __VinylError("Error in ", self, " for blend property\nKnob \"", _knobName, "\" doesn't exist");
            
                _knob.__TargetCreate(self, "blend");
                _blend = _knob.__OutputGet(); //Set blend to the current value of the knob
            }
            else
            {
                __VinylError("Error in ", self, "\n\"blend\" must be a number, a knob name, or undefined");
            }
        }
        else if (!is_numeric(_gain) && !is_undefined(_gain))
        {
            __VinylError("Error in ", self, "\n\"blend\" must be a number, a knob name, or undefined");
        }
        
        __blendFactorLocal = _blend;
        
        //Set the normalization state
        if (!is_bool(_blendNormalize))
        {
            __VinylError("Error in pattern ", self, "\n\"blend normalize\" must be a boolean (<true> or <false>)");
        }
        
        __blendNormalize = _blendNormalize;
        
        //Set the sync state
        if (!is_bool(_sync))
        {
            __VinylError("Error in pattern ", self, "\n\"sync\" must be a boolean (<true> or <false>)");
        }
        
        __sync = _sync;
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(__labelArray), ", persistent=", __persistent);
    }
    
    static __MultiBlendSet = function(_blend)
    {
        __blendFactorLocal = _blend;
    }
    
    static __Play = function(_parentInstance, _vinylEmitter, _sound, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _instance = __pool.__Depool();
        _instance.__Instantiate(self, _parentInstance, _vinylEmitter, __assetArray, _loop, _gain, _pitch, _pan, __sync);
        return _instance;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1)
    {
        __VinylError("Cannot use VinylPlaySimple() with a multi pattern");
    }
}
