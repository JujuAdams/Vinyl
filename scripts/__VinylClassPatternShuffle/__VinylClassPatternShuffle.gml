/// @param name
/// @param patternArray

function __VinylClassPatternShuffle(_name, _patternArray) constructor
{ 
    array_push(_patternArray, self);
    
    __name = _name;
    
    
    
    static toString = function()
    {
        return "<shuffle " + string(__name) + ">";
    }
    
    #region Initialize
    
    static __Initialize = function(_patternData = {}, _labelDict, _knobDict)
    {
        __assetArray = _patternData[$ "assets"] ?? (_patternData[$ "asset"] ?? []);
        
        __currentIndex = 0;
        __currentSize  = ceil(array_length(__assetArray)/3);
        __currentArray = array_create(__currentSize);
        
        if (__currentSize <= 0) __VinylError("Error in ", self, "\nShuffle patterns must have at least one member");
        
        //Convert any basic patterns into audio asset indexes
        var _i = 0;
        repeat(array_length(__assetArray))
        {
            var _pattern = __assetArray[_i];
            if (asset_get_type(_pattern) == asset_sound) __assetArray[@ _i] = asset_get_index(_pattern);
            ++_i;
        }
        
        //Initialize the currently-playing array with a random sample from the overall pattern array
        __VinylArrayShuffle(__assetArray);
        array_copy(__currentArray, 0, __assetArray, 0, __currentSize);
        array_delete(__assetArray, 0, __currentSize);
        
        
        
        //Set the gain/pitch state from the provided struct
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _effectChainName = _patternData[$ "effect chain"];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        
        
        if (!is_numeric(_gain)) __VinylError("Error in pattern ", self, "\nGain must be a number");
        __gain = _gain;
        
        if (is_numeric(_pitch) && (_pitch >= 0))
        {
            __pitchLo = _pitch;
            __pitchHi = _pitch;
        }
        else if (is_array(_pitch))
        {
            if (array_length(_pitch) != 2) __VinylError("Error in pattern ", self, "\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
            
            __pitchLo = _pitch[0];
            __pitchHi = _pitch[1];
            
            if (__pitchLo > __pitchHi)
            {
                __VinylTrace("Warning! Error in pattern ", self, ". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
                var _temp = __pitchLo;
                __pitchLo = __pitchHi;
                __pitchHi = _temp;
            }
        }
        else
        {
            __VinylError("Error in pattern ", self, "\nPitch must be either a number greater than or equal to zero, or a two-element array");
        }
        
        __effectChainName = _effectChainName;
        
        __labelArray = [];
        __labelDictTemp__ = {}; //Removed at the end of VinylSystemReadConfig()
        
        
        
        //Process label string to extract each label name
        var _labelNameArray = _patternData[$ "label"] ?? _patternData[$ "labels"];
        if (is_string(_labelNameArray)) _labelNameArray = [_labelNameArray];
        
        if (is_array(_labelNameArray))
        {
            var _i = 0;
            repeat(array_length(_labelNameArray))
            {
                var _labelName =_labelNameArray[_i];
                
                var _labelData = _labelDict[$ _labelName];
                if (_labelData == undefined)
                {
                    __VinylTrace("Warning! Label \"", _labelName, "\" could not be found (", self, ")");
                }
                else
                {
                    _labelData.__BuildAssetLabelArray(__labelArray, __labelDictTemp__);
                }
                
                ++_i;
            }
        }
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Created ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", label=", __VinylDebugLabelNames(_labelArray));
    }
    
    #endregion
    
    
    
    static __PopPattern = function()
    {
        if (__currentIndex >= __currentSize)
        {
            //Copy the currently playing array back to the main pattern array
            array_copy(__assetArray, array_length(__assetArray), __currentArray, 0, __currentSize);
            
            //Copy the next set of random patterns over to the current array, then remove them from the pattern array
            array_copy(__currentArray, 0, __assetArray, 0, __currentSize);
            array_delete(__assetArray, 0, __currentSize);
            
            //Reshuffle
            __VinylArrayShuffle(__assetArray);
            
            __currentIndex = 0;
        }
        
        var _pattern = __currentArray[__currentIndex];
        ++__currentIndex;
        return _pattern;
    }
    
    static __Play = function(_soundUnused, _loop = false, _gain = 1, _pitch = 1, _pan = undefined)
    {
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__Play(_pattern, _loop, _gain, _pitch, _pan);
    }
    
    static __PlaySimple = function(_soundUnused, _gain = 1, _pitch = 1)
    {
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__PlaySimple(_pattern, _gain, _pitch);
    }
}