/// @param sound
/// @param newLabelDict
/// @param [gain=0]
/// @param [freq=1]
/// @param [labelString]

function __VinylClassAsset(_sound, _newLabelDict, _gain = 0, _freq = 1, _labelString = undefined) constructor
{
    __sound = _sound;
    __gain  = _gain;
    __freq  = _freq;
    
    if (VINYL_DEBUG || VINYL_VERBOSE) __name = audio_get_name(__sound);
    
    __labelArray = [];
    
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
    
    static __UpdateInstances = function(_oldLabel)
    {
        var _gainDelta = __gain - _oldLabel.__gain;
        var _freqDelta = __freq / _oldLabel.__freq;
        
        if ((_gainDelta != 0) || (_freqDelta != 1))
        {
            var _i = 0;
            repeat(array_length(global.__vinylPlaying))
            {
                var _instance = global.__vinylPlaying[_i];
                if (_instance.__sound == __sound)
                {
                    _instance.__outputGain += _gainDelta;
                    _instance.__outputFreq *= _freqDelta;
                }
                
                ++_i;
            }
        }
    }
}