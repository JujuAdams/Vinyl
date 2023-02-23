function __VinylClassPatternFallback() : __VinylClassPatternCommon() constructor
{
    static __patternType = "fallback";
    static __pool = __VinylGlobalData().__poolBasic;
    
    static toString = function()
    {
        return "<fallback>";
    }
    
    static __Initialize = function(_patternData = {}, _knobDict, _labelDict)
    {
        if (VINYL_VALIDATE_CONFIG) __ValidateStruct(_patternData, ["gain", "pitch", "effect chain", "label", "labels"]);
        
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _effectChainName = _patternData[$ "effect chain"];
        var _labelNameArray  = _patternData[$ "label"       ] ?? _patternData[$ "labels"];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        __InitializeGain(_gain, _knobDict);
        __InitializePitch(_pitch, _knobDict);
        __InitializeEffectChain(_effectChainName);
        __InitializeLabelArray(_labelNameArray, _labelDict);
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(_labelArray));
    }
    
    static __Play = function(_emitter, _sound, _loop = false, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _instance = __pool.__Depool();
        _instance.__Play(_emitter, _sound, _loop, _gain, _pitch, _pan);
        return _instance;
    }
    
    static __PlaySimple = function(_sound, _gain = 1, _pitch = 1)
    {
        return __VinylPlaySimple(_sound, _gain*__gain, _pitch*__pitchLo, _pitch*__pitchHi, __labelArray, __effectChainName);
    }
}