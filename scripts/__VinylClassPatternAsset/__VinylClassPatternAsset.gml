/// @param name
/// @param adHoc

function __VinylClassPatternAsset(_name, _adHoc) : __VinylClassPatternCommon() constructor
{
    static __patternType = "asset";
    static __pool = __VinylGlobalData().__poolAsset;
    
    __name  = _name;
    __adHoc = _adHoc;
    __asset = undefined;
    
    static toString = function()
    {
        return (__asset == undefined)? "<asset ???>" : "<asset " + audio_get_name(__asset) + ">";
    }
    
    static __Initialize = function(_patternData = {})
    {
        if (VINYL_CONFIG_VALIDATE_PATTERNS) __ValidateStruct(_patternData, ["type", "asset", "assets", "gain", "pitch", "loop", "effect chain", "label", "labels", "loop point", "loop points"]);
        
        var _asset           = _patternData[$ "asset"       ] ?? _patternData[$ "assets"];
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _loop            = _patternData[$ "loop"        ];
        var _effectChainName = _patternData[$ "effect chain"] ?? _patternData[$ "effect"];
        var _loopPoints      = _patternData[$ "loop points" ] ?? _patternData[$ "loop point"];
        var _labelNameArray  = _patternData[$ "label"       ] ?? _patternData[$ "labels"];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        
        
        //Sort out the asset
        if (is_string(_asset))
        {
            if (asset_get_index(_asset) < 0) __VinylError("Error in ", self, " for \"asset\" property\nAsset \"", _asset, "\" not found in the project");
            if (asset_get_type(_asset) != asset_sound) __VinylError("Error in ", self, " for \"asset\" property\nAsset \"", _asset, "\" not a sound asset");
            _asset = asset_get_index(_asset);
        }
        
        if (!is_numeric(_asset)) __VinylError("Error in ", self, " for \"asset\" property\nAsset should be specified as an audio asset index or audio asset name (datatype=", typeof(_asset), ")");
        if (!audio_exists(_asset)) __VinylError("Error in ", self, " for \"asset\" property\nAudio asset with index ", _asset, " not found");
        
        __asset = _asset;
        
        
        
        __InitializeGain(_gain);
        __InitializePitch(_pitch);
        __InitializeLoop(_loop);
        __InitializeEffectChain(_effectChainName);
        __InitializeLoopPoints(_loopPoints);
        __InitializeLabelArray(_labelNameArray);
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(__labelArray));
    }
    
    static __Play = function(_parentInstance, _vinylEmitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _instance = __pool.__Depool();
        _instance.__Instantiate(self, _parentInstance, _vinylEmitter, __asset, _loop, _gain, _pitch, _pan);
        return _instance;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1)
    {
        return __VinylPlaySimple(__asset, _gain*__gain, _pitch*__pitchLo, _pitch*__pitchHi, __labelArray, __effectChainName);
    }
}