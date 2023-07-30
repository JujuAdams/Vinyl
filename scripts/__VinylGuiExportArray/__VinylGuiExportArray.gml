function __VinylGuiExportArray(_value)
{
    if (!is_array(_value)) return "";
    
    var _array = _value;
    var _string = "";
    
    var _size = array_length(_array);
    var _i = 0;
    repeat(_size)
    {
        var _foundValue = _array[_i];
        
        if (is_numeric(_foundValue))
        {
            _string += string_format(_foundValue, 0, 3);
        }
        else
        {
            _string += string(_foundValue);
        }
        
        if (_i < _size-1) _string += ", ";
        ++_i;
    }
    
    return _string;
}