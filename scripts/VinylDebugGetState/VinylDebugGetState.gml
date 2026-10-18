/// @param returnString

function VinylDebugGetState(_returnString)
{
    static _system = __VinylSystem();
    
    var _data = [];
    array_push(_data, "masterGain", _system.__masterGain);
    array_push(_data, "masterMute", _system.__masterMute);
    array_push(_data, "audio_get_master_gain(0)", audio_get_master_gain(0));
    
    var _mixGroupArray = _system.__mixGroupArray;
    var _i = 0;
    repeat(array_length(_mixGroupArray))
    {
        var _mixGroup = _mixGroupArray[_i];
        var _exportName = _mixGroup.__exportName;
        
        array_push(_data, $"{_exportName}.gain", _mixGroup.__gain / _mixGroup.__trim);
        array_push(_data, $"{_exportName}.mute", _mixGroup.__mute);
        array_push(_data, $"{_exportName}.trim", _mixGroup.__trim);
        array_push(_data, $"{_exportName}.globalEmitter", _mixGroup.__globalEmitbus.__gmEmitter);
        array_push(_data, $"{_exportName}.globalBus.ptr(bus)", ptr(_mixGroup.__globalEmitbus.__bus));
        array_push(_data, $"{_exportName}.globalBus.bus", _mixGroup.__globalEmitbus.__bus);
        
        ++_i;
    }
    
    if (not _returnString) return _data;
    
    var _funcStringify = function(_funcStringify, _string, _indent, _data)
    {
        var _count = array_length(_data);
        var _i = 0;
        while(_i < _count)
        {
            var _key = _data[_i++];
            if (is_array(_key))
            {
                _string = _funcStringify(_funcStringify, _string, _indent + "    ", _key);
            }
            else
            {
                var _value = _data[_i++];
                
                if (is_struct(_value))
                {
                    _value = json_stringify(_value, true);
                }
                
                _string += $"{_indent}{_key} = {_value}\n";
            }
        }
        
        return _string;
    }
    
    return _funcStringify(_funcStringify, "", "", _data);
}