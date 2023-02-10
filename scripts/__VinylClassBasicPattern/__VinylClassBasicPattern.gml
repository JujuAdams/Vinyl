/// @param sound
/// @param patternArray
/// @param labelDict
/// @param [patternData]

function __VinylClassBasicPattern(_sound, _patternArray, _labelDict, _patternData = {}) constructor
{
    array_push(_patternArray, self);
    
    __sound = _sound;
    __name  = audio_get_name(__sound);
    
    var _gain       = _patternData[$ "gain" ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
    var _pitch      = _patternData[$ "pitch"] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
    var _busName    = _patternData[$ "effect bus"] ?? _patternData[$ "effect buss"];
    var _loopPoints = _patternData[$ "loop points"];
    
    if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
    if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
    
    if (!is_numeric(_gain)) __VinylError("Error in audio asset \"", __name, "\"\nGain must be a number");
    __gain = _gain;
    
    if (is_numeric(_pitch) && (_pitch >= 0))
    {
        __pitchLo = _pitch;
        __pitchHi = _pitch;
    }
    else if (is_array(_pitch))
    {
        if (array_length(_pitch) != 2) __VinylError("Error in audio asset \"", __name, "\"\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
        
        __pitchLo = _pitch[0];
        __pitchHi = _pitch[1];
        
        if (__pitchLo > __pitchHi)
        {
            __VinylTrace("Warning! Error in audio asset \"", __name, "\". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
            var _temp = __pitchLo;
            __pitchLo = __pitchHi;
            __pitchHi = _temp;
        }
    }
    else
    {
        __VinylError("Error in audio asset \"", __name, "\"\nPitch must be either a number greater than or equal to zero, or a two-element array");
    }
    
    if (is_string(_busName) || is_undefined(_busName))
    {
        __busName = _busName;
    }
    else
    {
        __VinylError("Error in audio asset \"", __name, "\"\nBus must be a name (as a string)");
    }
    
    if (is_array(_loopPoints))
    {
         if (array_length(_loopPoints) != 2) __VinylError("Error in audio asset \"", __name, "\"\nLoop point array must have exactly two elements (length=", array_length(_pitch), ")");
         if (!is_numeric(_loopPoints[0])) __VinylError("Error in audio asset \"", __name, "\"\nLoop point array elements must be numbers (index 0 datatype=", typeof(_loopPoints[0]), ")");
         if (!is_numeric(_loopPoints[1])) __VinylError("Error in audio asset \"", __name, "\"\nLoop point array elements must be numbers (index 1 datatype=", typeof(_loopPoints[1]), ")");
         
         __loopPoints = _loopPoints;
    }
    else if (is_undefined(_loopPoints))
    {
        __loopPoints = _loopPoints;
    }
    else
    {
        __VinylError("Error in audio asset \"", __name, "\"\nLoop points must be a two-element array");
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
                __VinylTrace("Warning! Label \"", _labelName, "\" could not be found (asset was \"", __name, "\")");
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
    
    static __PlaySimple = function(_gain = 1, _pitch = 1, _sound = __sound)
    {
        var _randomPitchParam = __VinylRandom(1);
        
        _gain *= __gain;
        var _assetPitch = lerp(__pitchLo, __pitchHi, _randomPitchParam);
        _pitch *= _assetPitch;
        
        var _i = 0;
        repeat(array_length(__labelArray))
        {
            var _label = __labelArray[_i];
            
            _gain *= _label.__outputGain;
            var _labelPitch = lerp(_label.__configPitchLo, _label.__configPitchHi, _randomPitchParam);
            _pitch *= _labelPitch*_label.__outputPitch;
            
            ++_i;
        }
        
        var _busEmitter = __VinylEffectBusGetEmitter(__busName);
        if (_busEmitter == undefined)
        {
            var _instance = audio_play_sound(_sound, 1, false, __VinylCurveAmplitude(_gain), 0, _pitch);
        }
        else
        {
            var _instance = audio_play_sound_on(_busEmitter, _sound, false, 1, __VinylCurveAmplitude(_gain), 0, _pitch);
        }
        
        if (VINYL_DEBUG_LEVEL >= 1)
        {
            __VinylTrace("Playing ", __name, ", gain=", _gain, ", pitch=", _pitch, ", label=", __DebugLabelNames(), " (GMinst=", _instance, ", amplitude=", _gain/VINYL_MAX_GAIN, ")");
        }
        
        if (_gain > VINYL_MAX_GAIN)
        {
            __VinylTrace("Warning! Gain value ", _gain, " exceeds VINYL_MAX_GAIN (", VINYL_MAX_GAIN, ")");
        }
        
        return _instance;
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