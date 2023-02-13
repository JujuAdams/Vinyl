/// @param sound
/// @param patternArray

function __VinylClassPatternBasic(_sound, _patternArray) constructor
{
    array_push(_patternArray, self);
    
    __sound = _sound;
    __name  = (__sound < 0)? "fallback" : audio_get_name(__sound);
    
    
    
    static toString = function()
    {
        return "<basic " + __name + ">";
    }
    
    #region Initialize
    
    static __Initialize = function(_patternData = {}, _knobDict, _labelDict)
    {
        var _gain            = _patternData[$ "gain"        ] ?? (VINYL_CONFIG_DECIBEL_GAIN? 0 : 1);
        var _pitch           = _patternData[$ "pitch"       ] ?? (VINYL_CONFIG_PERCENTAGE_PITCH? 100 : 1);
        var _effectChainName = _patternData[$ "effect chain"];
        var _loopPoints      = _patternData[$ "loop points" ];
        
        if (VINYL_CONFIG_DECIBEL_GAIN) _gain = __VinylGainToAmplitude(_gain);
        if (VINYL_CONFIG_PERCENTAGE_PITCH) _pitch /= 100;
        
        
        
        //Sort out the gain
        if (is_string(_gain))
        {
            if (string_char_at(_gain, 1) == "@")
            {
                var _knobName = string_delete(_gain, 1, 1);
                var _knob = _knobDict[$ _knobName];
                if (!is_struct(_knob)) __VinylError("Error in ", self, " for gain property\nKnob \"", _knobName, "\" doesn't exist");
            
                _knob.__TargetCreate(self, "gain");
                _gain = _knob.__actualValue; //Set gain to the current value of the knob
            }
            else
            {
                __VinylError("Error in ", self, "\nGain must be a number or a knob name");
            }
        }
        else if (!is_numeric(_gain))
        {
            __VinylError("Error in ", self, "\nGain must be a number or a knob name");
        }
        
        __gain = _gain;
        
        
        
        //Sort out the pitch
        if (is_string(_pitch))
        {
            if (string_char_at(_pitch, 1) == "@")
            {
                var _knobName = string_delete(_pitch, 1, 1);
                var _knob = _knobDict[$ _knobName];
                if (!is_struct(_knob)) __VinylError("Error in ", self, " for pitch property\nKnob \"", _knobName, "\" doesn't exist");
                
                _knob.__TargetCreate(self, "pitch");
                __pitchLo = _knob.__actualValue; //Set pitch to the current value of the knob
                __pitchHi = __pitchLo;
                
                __configPitchKnob = true;
            }
            else
            {
                __VinylError("Error in ", self, "\nPitch must be either a number greater than zero, a two-element array, or a knob name");
            }
        }
        else if (is_numeric(_pitch) && (_pitch >= 0))
        {
            __pitchLo = _pitch;
            __pitchHi = _pitch;
        }
        else if (is_array(_pitch))
        {
            if (array_length(_pitch) != 2) __VinylError("Error in ", self, "\nPitch array must have exactly two elements (length=", array_length(_pitch), ")");
            
            __pitchLo = _pitch[0];
            __pitchHi = _pitch[1];
            
            if (__pitchLo > __pitchHi)
            {
                __VinylTrace("Warning! Error in ", self, ". Low pitch (", __pitchLo, ") is greater than high pitch (", __pitchHi, ")");
                var _temp = __pitchLo;
                __pitchLo = __pitchHi;
                __pitchHi = _temp;
            }
        }
        else
        {
            __VinylError("Error in ", self, "\nPitch must be either a number greater than zero, a two-element array, or a knob name");
        }
        
        
        
        //Sort out the effect chain
        if (is_string(_effectChainName) || is_undefined(_effectChainName))
        {
            __effectChainName = _effectChainName;
        }
        else
        {
            __VinylError("Error in ", self, "\nBus must be a name (as a string)");
        }
        
        
        
        //Now loop points...
        if (is_array(_loopPoints))
        {
             if (array_length(_loopPoints) != 2) __VinylError("Error in audio asset ", self, "\nLoop point array must have exactly two elements (length=", array_length(_pitch), ")");
             if (!is_numeric(_loopPoints[0])) __VinylError("Error in ", self, "\nLoop point array elements must be numbers (index 0 datatype=", typeof(_loopPoints[0]), ")");
             if (!is_numeric(_loopPoints[1])) __VinylError("Error in ", self, "\nLoop point array elements must be numbers (index 1 datatype=", typeof(_loopPoints[1]), ")");
            
             __loopPoints = _loopPoints;
        }
        else if (is_undefined(_loopPoints))
        {
            __loopPoints = _loopPoints;
        }
        else
        {
            __VinylError("Error in ", self, "\nLoop points must be a two-element array");
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
                    __VinylTrace("Warning! Label \"", _labelName, "\" could not be found (", self, ")");
                }
                else
                {
                    _labelData.__BuildAssetLabelArray(__labelArray, __labelDictTemp__);
                }
                
                ++_i;
            }
        }
        
        if (VINYL_DEBUG_READ_CONFIG) __VinylTrace("Creating asset definition for ", self, ", gain=", __gain, ", pitch=", __pitchLo, " -> ", __pitchHi, ", label=", __VinylDebugLabelNames(_labelArray));
    }
    
    #endregion
    
    
    
    static __Play = function(_emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        static __pool = __VinylGlobalData().__poolBasic;
        
        var _instance = __pool.__Depool();
        _instance.__Play(_emitter, _sound, _loop, _gain, _pitch, _pan);
        
        return _instance;
    }
    
    static __PlaySimple = function(_sound = __sound, _gain = 1, _pitch = 1)
    {
        return __VinylPlaySimple(_sound, _gain*__gain, _pitch*__pitchLo, _pitch*__pitchHi, __labelArray, __effectChainName);
    }
}