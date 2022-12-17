/// @param sound
/// @param newLabelDict
/// @param [gain=0]
/// @param [pitch=1]
/// @param [labelString]

function __VinylClassAsset(_sound, _newLabelDict, _gain = 0, _pitch = 1, _labelString = undefined) constructor
{
    __sound = _sound;
    __gain  = _gain;
    __pitch  = _pitch;
    
    if (VINYL_DEBUG) __name = audio_get_name(__sound);
    
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
    
    static __UpdateInstances = function(_oldAsset)
    {
        var _gainDelta  = __gain - _oldAsset.__gain;
        var _pitchDelta = __pitch / _oldAsset.__pitch;
        
        if ((_gainDelta != 0) || (_pitchDelta != 1))
        {
            var _i = 0;
            repeat(array_length(global.__vinylPlaying))
            {
                var _instance = global.__vinylPlaying[_i];
                if (_instance.__sound == __sound)
                {
					_instance.__outputChanged = true;
					
                    _instance.__outputGain += _gainDelta;
                    _instance.__outputPitch *= _pitchDelta;
                }
                
                ++_i;
            }
        }
    }
}