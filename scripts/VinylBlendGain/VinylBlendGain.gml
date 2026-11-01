/// Blends gains for an array of voices. The `factor` parameter cross-fades between voices with a
/// value of `0` indicating the first voice should be heard to the exclusion of all other vocies,
/// a value of `1` indicating the second voice should be heard et cetera. The `sharedGain`
/// parameter is multiplicative with the blended gain and can be used to control the overall gain.
/// for all voices in the array. The per-sound gains, set by `VinylDefineSound()`, will be
/// respected by this function. The time parameter is measured in milliseconds.
/// 
/// @param voiceArray
/// @param factor
/// @param [time=0]
/// @param [sharedGain=1]

function VinylBlendGain(_voiceArray, _factor, _time = 0, _sharedGain = 1)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_voiceArray))
    {
        var _count = array_length(_voiceArray);
        _factor = clamp(_factor, 0, _count - 1);
        
        var _i = 0;
        repeat(_count)
        {
            VinylSetGain(_voiceArray[_i], _sharedGain*max(0, 1 - abs(_i - _factor)), _time);
            ++_i;
        }
    }
    else
    {
        VinylSetGain(_voiceArray, _sharedGain, _time);
    }
}