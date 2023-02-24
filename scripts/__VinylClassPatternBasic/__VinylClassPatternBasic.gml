/// @param name
/// @param adHoc

function __VinylClassPatternBasic(_name, _adHoc) : __VinylClassPatternCommon() constructor
{
    static __patternType = "basic";
    static __pool = __VinylGlobalData().__poolBasic;
    
    __name  = _name;
    __adHoc = _adHoc;
    __asset = undefined;
    
    static toString = function()
    {
        return (__asset == undefined)? "<basic ???>" : "<basic " + audio_get_name(__asset) + ">";
    }
    
    static __Initialize = function(_patternData = {}, _knobDict, _labelDict)
    {
        if (VINYL_CONFIG_VALIDATE_PATTERNS) __ValidateStruct(_patternData, ["type", "asset", "assets", "gain", "pitch", "loop", "effect chain", "label", "labels", "loop point", "loop points", "copyTo"]);
        
        var _asset           = _patternData[$ "asset"       ] ?? _patternData[$ "assets"];
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _loop            = _patternData[$ "loop"        ];
        var _effectChainName = _patternData[$ "effect chain"];
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
        
        
        
        __InitializeGain(_gain, _knobDict);
        __InitializePitch(_pitch, _knobDict);
        __InitializeLoop(_loop);
        __InitializeEffectChain(_effectChainName);
        __InitializeLoopPoints(_loopPoints);
        __InitializeLabelArray(_labelNameArray, _labelDict);
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", effect chain=", __effectChainName, ", label=", __VinylDebugLabelNames(_labelArray));
    }
    
    static __CopyTo = function(_patternData, _newPatternDict, _newPatternArray, _newKnobDict, _newLabelDict)
    {   
        var _copyToArray = _patternData[$ "copyTo"];
        if (is_string(_copyToArray)) _copyToArray = [_copyToArray]; //Create an array out of a string if needed
        
        if (is_array(_copyToArray))
        {
            var _j = 0;
            repeat(array_length(_copyToArray))
            {
                var _copyToName = _copyToArray[_j];
                var _copyToIndex = asset_get_index(_copyToName);
                var _copyToKey = string(_copyToIndex);
                
                if (_copyToName == "fallback")
                {
                    __VinylTrace("Warning! Cannot copy to fallback asset (parent asset=\"", __name, "\")");;
                }
                else if (_copyToIndex < 0)
                {
                    __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" doesn't exist (parent asset=\"", __name, "\")");
                }
                else if (asset_get_type(_copyToName) != asset_sound)
                {
                    __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" isn't a sound (parent asset=\"", __name, "\")");
                }
                else if (variable_struct_exists(_newPatternDict, _copyToKey))
                {
                    __VinylTrace("Warning! copyTo asset \"", _copyToName, "\" has already been defined (parent asset=\"", __name, "\")");
                }
                else
                {
                    //Spoof a proper Basic pattern data struct
                    _patternData.asset = _copyToIndex;
                    
                    var _pattern = new __VinylClassPatternBasic(_copyToKey, false);
                    _pattern.__Initialize(_patternData, _newKnobDict, _newLabelDict);
                    
                    array_push(_newPatternArray, _pattern);
                    _newPatternDict[$ _copyToKey] = _pattern;
                }
                
                ++_j;
            }
        }
    }
    
    static __Play = function(_parentInstance, _emitter, _sound_UNUSED, _loop = undefined, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _instance = __pool.__Depool();
        _instance.__Instantiate(self, _parentInstance, _emitter, __asset, _loop, _gain, _pitch, _pan);
        return _instance;
    }
    
    static __PlaySimple = function(_sound_UNUSED, _gain = 1, _pitch = 1)
    {
        return __VinylPlaySimple(__asset, _gain*__gain, _pitch*__pitchLo, _pitch*__pitchHi, __labelArray, __effectChainName);
    }
}