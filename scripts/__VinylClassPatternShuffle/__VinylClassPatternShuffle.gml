// Feather disable all
/// @param name
/// @param adHoc
/// @param child

function __VinylClassPatternShuffle(_name, _adHoc, _child) : __VinylClassPatternCommon() constructor
{
    static __patternType = "shuffle";
    static __pool = __VinylGlobalData().__poolBasic; //No need for a dedicated shuffle voice
    
    __name  = _name;
    __adHoc = _adHoc;
    __child = _child;
    
    static toString = function()
    {
        return "<shuffle " + string(__name) + ">";
    }
    
    static __Initialize = function(_patternData = {})
    {
        if (!is_struct(_patternData)) __VinylError("Error in ", self, "\nPattern data must be a struct");
        if (VINYL_CONFIG_VALIDATE_PROPERTIES) __VinylValidateStruct(_patternData, ["type", "asset", "assets", "assetsWithTag", "gain", "pitch", "transpose", "loop", "stack", "stack priority", "persistent", "effect chain", "label", "labels"]);
        
        //Set the gain/pitch state from the provided struct
        var _assetArray      = _patternData[$ "assets"        ] ?? (_patternData[$ "asset"] ?? []);
        var _tagArray        = _patternData[$ "assetsWithTag" ];
        var _gain            = _patternData[$ "gain"          ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"         ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _transpose       = _patternData[$ "transpose"     ];
        var _loop            = _patternData[$ "loop"          ];
        var _persistent      = _patternData[$ "persistent"    ];
        var _stack           = _patternData[$ "stack"         ];
        var _stackPriority   = _patternData[$ "stack priority"] ?? 0;
        var _effectChainName = _patternData[$ "effect chain"  ] ?? _patternData[$ "effect"];
        var _labelNameArray  = _patternData[$ "label"         ] ?? _patternData[$ "labels"];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        __InitializeAssetArray(_assetArray, _tagArray);
        __InitializeGain(_gain);
        __InitializePitch(_pitch);
        __InitializeTranspose(_transpose);
        __InitializeLoop(_loop);
        __InitializePersistent(_persistent);
        __InitializeStack(_stack, _stackPriority);
        __InitializeEffectChain(_effectChainName);
        __InitializeLabelArray(_labelNameArray);
        
        //Set up tracking for shuffle pattern
        __currentIndex = 0;
        
        //Initialize the currently-playing array with a random sample from the overall pattern array
        __VinylArrayShuffle(__assetArray);
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gainLo, " -> ", __gainHi, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(__labelArray), ", persistent=", __persistent);
    }
    
    static __PopPattern = function()
    {
        var _pattern = __assetArray[__currentIndex];
        
        ++__currentIndex;
        if (__currentIndex >= array_length(__assetArray))
        {
            //Reshuffle
            __VinylArrayShuffle(__assetArray);
            
            //Ensure we don't play the same sound twice in a row
            if (__assetArray[0] == _pattern)
            {
                array_delete(__assetArray, 0, 1);
                array_insert(__assetArray, ceil(array_length(__assetArray)/2), _pattern);
            }
            
            __currentIndex = 0;
        }
        
        return _pattern;
    }
    
    static __Play = function(_patternTop, _parentVoice, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _voice = __pool.__Depool();
        _voice.__Instantiate(_patternTop, self, _parentVoice, _vinylEmitter, __PopPattern(), _loop, _gain, _pitch, _pan);
        return _voice;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gainLo, _gainHi, _pitchLo, _pitchHi, _labelArray, _effectChainName = __effectChainName)
    {
        __VinylAppendArray(__labelArray, _labelArray);
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__PlaySimple(_pattern, _gainLo*__gainLo, _gainHi*__gainHi, _pitchLo*__pitchLo, _pitchHi*__pitchHi, _labelArray, _effectChainName);
    }
}
