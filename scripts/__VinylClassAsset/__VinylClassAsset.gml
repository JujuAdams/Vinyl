/// @param sound
/// @param labelDict
/// @param [assetData]

function __VinylClassAsset(_sound, _labelDict, _assetData = {}) constructor
{ 
    __sound = _sound;
    __gain  = _assetData[$ "gain" ] ?? 0;
    __pitch = _assetData[$ "pitch"] ?? 100;
    
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
    
    if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating asset definition for \"", audio_get_name(__sound), "\", gain=", __gain, " db, pitch=", __pitch, "%, label=", __DebugLabelNames());
    
    
    
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