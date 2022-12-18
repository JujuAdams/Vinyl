/// @param sound
/// @param newLabelDict
/// @param [assetData]

function __VinylClassAsset(_sound, _newLabelDict, _assetData = {}) constructor
{ 
    __sound = _sound;
    __gain  = _assetData[$ "gain" ] ?? 0;
    __pitch = _assetData[$ "pitch"] ?? 1;
    
    if (VINYL_DEBUG_LEVEL >= 1) __name = audio_get_name(__sound);
    
    __labelArray = [];
    
    
    
    //Process label string to extract each label name
    var _labelString = _assetData[$ "label"] ?? _assetData[$ "labels"];
    if (is_string(_labelString))
    {
        _labelString += ",";
        
        var _prevPos = 1;
        var _pos = string_pos_ext(",", _labelString, _prevPos);
        while(_pos > 0)
        {
            var _substring = string_copy(_labelString, _prevPos, _pos - _prevPos);
                _substring = string_replace_all(_substring, " ", "");
            
            var _labelData = _newLabelDict[$ _substring];
            if (_labelData == undefined)
            {
                __VinylTrace("Warning! Label \"", _substring, "\" could not be found (asset was \"", audio_get_name(__sound), "\")");
            }
            else
            {
                array_push(__labelArray, _labelData);
            }
            
            _prevPos = _pos+1;
            _pos = string_pos_ext(",", _labelString, _prevPos);
        }
    }
    
    if (VINYL_DEBUG_PARSER) __VinylTrace("Creating asset definition for \"", audio_get_name(__sound), "\", gain=", __gain, " db, pitch=", 100*__pitch, "%, label=", __DebugLabelNames());
    
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
        if (VINYL_DEBUG_LEVEL <= 0) return "";
        
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