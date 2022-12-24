/// @param sound
/// @param labelDict
/// @param [assetData]

function __VinylClassAsset(_sound, _labelDict, _assetData = {}) constructor
{ 
    __sound = _sound;
    
    var _gain  = _assetData[$ "gain" ] ?? 0;
    var _pitch = _assetData[$ "pitch"] ?? 100;
    
    if (!is_numeric(_gain)) __VinylError("Error in label \"", __name, "\"\nGain must be a number");
    __gain = _gain;
    
    if (is_numeric(_pitch) && (_pitch >= 0))
    {
        __pitchLo = _pitch;
        __pitchHi = _pitch;
    }
    else if (is_array(_pitch))
    {
        if (array_length(_pitch) != 2) __VinylError("Error in label \"", __name, "\"\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
        __pitchLo = _pitch[0];
        __pitchHi = _pitch[1];
        
        if (__pitchLo > __pitchHi)
        {
            if (GM_build_type == "run")
            {
                __VinylError("Warning! Error in label \"", __name, "\"\nLow pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
            }
            else
            {
                __VinylTrace("Warning! Error in label \"", __name, "\". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
            }
            
            var _temp = __pitchLo;
            __pitchLo = __pitchHi;
            __pitchHi = _temp;
        }
    }
    else
    {
        __VinylError("Error in label \"", __name, "\"\nPitch must be either a number greater than or equal to zero, or a two-element array");
    }
    
    if (VINYL_DEBUG_LEVEL >= 1) __name = audio_get_name(__sound);
    
    __labelArray = [];
    
    
    
    //Process label string to extract each label name
    var _labelNameArray = _assetData[$ "label"] ?? _assetData[$ "labels"];
    if (is_string(_labelNameArray)) _labelNameArray = [_labelNameArray];
    
    if (is_array(_labelNameArray))
    {
        var _foundLabelDict = {};
        var _i = 0;
        repeat(array_length(_labelNameArray))
        {
            var _labelName =_labelNameArray[_i];
            
            var _labelData = _labelDict[$ _labelName];
            if (_labelData == undefined)
            {
                __VinylTrace("Warning! Label \"", _labelName, "\" could not be found (asset was \"", audio_get_name(__sound), "\")");
            }
            else
            {
                _labelData.__BuildAssetLabelArray(__labelArray, _foundLabelDict);
            }
            
            ++_i;
        }
    }
    
    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating asset definition for \"", audio_get_name(__sound), "\", gain=", __gain, " db, pitch=", __pitchLo, "% -> ", __pitchHi, "%, label=", __DebugLabelNames());
    
    
    
    static __GetLoopFromLabel = function()
    {
        var _i = 0;
        repeat(array_length(__labelArray))
        {
            if (__labelArray[_i].__assetLoop == true) return true;
            ++_i;
        }
        
        return false;
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