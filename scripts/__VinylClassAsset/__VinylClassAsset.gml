/// @param sound
/// @param labelDict
/// @param [assetData]

function __VinylClassAsset(_sound, _labelDict, _assetData = {}) constructor
{ 
    __sound = _sound;
    
    var _gain  = _assetData[$ "gain" ] ?? 0;
    var _pitch = _assetData[$ "pitch"] ?? 100;
    
    if (!is_numeric(_gain)) __VinylError("Error in audio asset \"", audio_get_name(__sound), "\"\nGain must be a number");
    __gain = _gain;
    
    if (is_numeric(_pitch) && (_pitch >= 0))
    {
        __pitchLo = _pitch;
        __pitchHi = _pitch;
    }
    else if (is_array(_pitch))
    {
        if (array_length(_pitch) != 2) __VinylError("Error in audio asset \"", audio_get_name(__sound), "\"\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
        __pitchLo = _pitch[0];
        __pitchHi = _pitch[1];
        
        if (__pitchLo > __pitchHi)
        {
            __VinylTrace("Warning! Error in audio asset \"", audio_get_name(__sound), "\". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
            var _temp = __pitchLo;
            __pitchLo = __pitchHi;
            __pitchHi = _temp;
        }
    }
    else
    {
        __VinylError("Error in audio asset \"", audio_get_name(__sound), "\"\nPitch must be either a number greater than or equal to zero, or a two-element array");
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
    
    static __PlaySimple = function(_gain = 0, _pitch = 100)
    {
        var _randomPitchParam = __VinylRandom(1);
        
        var _asset = __VinylAssetGet(_sound);
        if (is_struct(_asset))
        {
            _gain += __gain;
            var _assetPitch = lerp(__pitchLo, __pitchHi, _randomPitchParam);
            _pitch *= _assetPitch/100;
            
            var _labelArray = _asset.__labelArray;
            var _i = 0;
            repeat(array_length(_labelArray))
            {
                var _label = _labelArray[_i];
                
                _gain += _label.__outputGain;
                var _labelPitch = lerp(_label.__assetPitchLo, _label.__assetPitchHi, _randomPitchParam)/100;
                _pitch *= _labelPitch*_label.__outputPitch/100;
                
                ++_i;
            }
        }
        
        var _instance = audio_play_sound(__sound, 1, false, __VinylGainToAmplitude(_gain - VINYL_SYSTEM_HEADROOM), 0, _pitch/100);
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Playing ", audio_get_name(__sound), ", gain=", _gain, " dB, pitch=", _pitch, "%, label=", __DebugLabelNames(), " (GMinst=", _instance, ", amplitude=", 100*__VinylGainToAmplitude(_gain - VINYL_SYSTEM_HEADROOM), "%)");
        }
        
        if (_gain > VINYL_SYSTEM_HEADROOM)
        {
            __VinylTrace("Warning! Gain value ", _gain, " exceeds VINYL_SYSTEM_HEADROOM (", VINYL_SYSTEM_HEADROOM, ")");
        }
        
        return _instance;
    }
    
    static __GetLoopFromLabel = function()
    {
        var _asset = __VinylAssetGet(__sound);
        return is_struct(_asset)? _asset.__GetLoopFromLabel() : false;
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