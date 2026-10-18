/// @param voiceOrArray
/// @param factor
/// @param [time=0]
/// @param [sharedGain=1]

function VinylSetBlendGain(_voiceOrArray, _factor, _time = 0, _sharedGain = 1)
{
    static _soundDefMap = __VinylSystem().__soundDefMap;
    
    if (is_array(_voiceOrArray))
    {
        var _count = array_length(_voiceOrArray);
        
        //Scale up the blend factor to match the number of channels we have
        _factor = clamp(_factor, 0, 1)*(_count - 1);
        
        var _i = 0;
        repeat(_count)
        {
            VinylSetGain(_voiceOrArray[_i], _sharedGain*max(0, 1 - abs(_i - _factor)), _time);
            ++_i;
        }
    }
    else
    {
        VinylSetGain(_voiceOrArray, _sharedGain, _time);
    }
}