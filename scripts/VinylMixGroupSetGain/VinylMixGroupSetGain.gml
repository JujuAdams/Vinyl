/// @param mixGroupIndex
/// @param gain

function VinylMixGroupSetGain(_mixGroupIndex, _gain)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    
    var _result = false;
    
    if (_gain != undefined)
    {
        with(_mixGroup)
        {
            _gain = clamp(__trim*_gain, 0, __VINYL_MAX_MIX_GROUP_GAIN);
            
            if (_gain != __gain)
            {
                __gain = _gain;
                _result = true;
                
                var _emitbusArray = __emitbusArray;
                var _i = 0;
                repeat(array_length(_emitbusArray))
                {
                    _emitbusArray[_i].__bus.gain = __gain;
                    ++_i;
                }
            }
        }
    }
    
    return _result;
}