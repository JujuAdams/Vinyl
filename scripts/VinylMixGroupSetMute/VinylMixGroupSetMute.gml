/// @param mixGroupIndex
/// @param state

function VinylMixGroupSetMute(_mixGroupIndex, _state)
{
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    
    var _result = false;
    
    if (_state != undefined)
    {
        with(_mixGroup)
        {
            if (_state != __mute)
            {
                __mute = _state;
                _result = true;
                
                var _setGain = _state? 0 : __gain;
                
                var _emitbusArray = __emitbusArray;
                var _i = 0;
                repeat(array_length(_emitbusArray))
                {
                    _emitbusArray[_i].__bus.gain = _setGain;
                    ++_i;
                }
            }
        }
    }
}