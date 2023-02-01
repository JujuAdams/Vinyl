/// @param name
/// @param patternArray
/// @param labelDict
/// @param [patternData]

function __VinylClassShufflePattern(_name, _patternArray, _labelDict, _patternData = {}) constructor
{ 
    array_push(_patternArray, self);
    
    __name         = _name;
    __patternArray = _patternData[$ "shuffle"] ?? [];
    
    __currentIndex = 0;
    __currentSize  = ceil(array_length(__patternArray)/3);
    __currentArray = array_create(__currentSize);
    
    if (__currentSize <= 0) __VinylError("Error in pattern \"", __name, "\"\nShuffle-type patterns must have at least one member");
    
    //Convert any basic patterns into audio asset indexes
    var _i = 0;
    repeat(array_length(__patternArray))
    {
        var _pattern = __patternArray[_i];
        if (asset_get_type(_pattern) == asset_sound) __patternArray[@ _i] = asset_get_index(_pattern);
        ++_i;
    }
    
    //Initialize the currently-playing array with a random sample from the overall pattern array
    __VinylArrayShuffle(__patternArray);
    array_copy(__currentArray, 0, __patternArray, 0, __currentSize);
    array_delete(__patternArray, 0, __currentSize);
    
    
    
    //Set the gain/pitch state from the provided struct
    var _gain  = _patternData[$ "gain" ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
    var _pitch = _patternData[$ "pitch"] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
    
    if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
    if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
    
    if (!is_numeric(_gain)) __VinylError("Error in pattern \"", __name, "\"\nGain must be a number");
    __gain = _gain;
    
    if (is_numeric(_pitch) && (_pitch >= 0))
    {
        __pitchLo = _pitch;
        __pitchHi = _pitch;
    }
    else if (is_array(_pitch))
    {
        if (array_length(_pitch) != 2) __VinylError("Error in pattern \"", __name, "\"\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
        __pitchLo = _pitch[0];
        __pitchHi = _pitch[1];
        
        if (__pitchLo > __pitchHi)
        {
            __VinylTrace("Warning! Error in pattern \"", __name, "\". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
            var _temp = __pitchLo;
            __pitchLo = __pitchHi;
            __pitchHi = _temp;
        }
    }
    else
    {
        __VinylError("Error in pattern \"", __name, "\"\nPitch must be either a number greater than or equal to zero, or a two-element array");
    }
    
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
                __VinylTrace("Warning! Label \"", _labelName, "\" could not be found (pattern was \"", __name, "\")");
            }
            else
            {
                _labelData.__BuildAssetLabelArray(__labelArray, __labelDictTemp__);
            }
            
            ++_i;
        }
    }
    
    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating asset definition for \"", __name, "\", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", label=", __DebugLabelNames());
    
    
    
    static __GetLoopFromLabel = function()
    {
        var _i = 0;
        repeat(array_length(__labelArray))
        {
            if (__labelArray[_i].__configLoop == true) return true;
            ++_i;
        }
        
        return false;
    }
    
    static __PopPattern = function()
    {
        if (__currentIndex >= __currentSize)
        {
            //Copy the currently playing array back to the main pattern array
            array_copy(__patternArray, array_length(__patternArray), __currentArray, 0, __currentSize);
            
            //Copy the next set of random patterns over to the current array, then remove them from the pattern array
            array_copy(__currentArray, 0, __patternArray, 0, __currentSize);
            array_delete(__patternArray, 0, __currentSize);
            
            //Reshuffle
            __VinylArrayShuffle(__patternArray);
            
            __currentIndex = 0;
        }
        
        var _pattern = __currentArray[__currentIndex];
        ++__currentIndex;
        
        return _pattern;
    }
    
    static __Play = function(_gain = 1, _pitch = 1, _pattern_UNUSED)
    {
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__Play(_gain, _pitch, _pattern);
    }
    
    static __PlaySimple = function(_gain = 1, _pitch = 1, _pattern_UNUSED)
    {
        var _pattern = __PopPattern();
        return __VinylPatternGet(_pattern).__PlaySimple(_gain, _pitch, _pattern);
    }
    
    static __DebugLabelNames = function()
    {
        var _labelReadable = "";
        
        var _size = array_length(__labelArray);
        if (_size > 1) _labelReadable += "[";
        
        var _i = 0;
        repeat(_size)
        {
            _labelReadable += __labelArray[_i].__name;
            if (_i < _size-1) _labelReadable += ", ";
            ++_i;
        }
        
        if (_size > 1) _labelReadable += "]";
        
        return _labelReadable;
    }
}