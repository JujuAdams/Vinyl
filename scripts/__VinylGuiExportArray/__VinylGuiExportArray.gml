function __VinylGuiExportArray(_value)
{
    if (!is_array(_value)) return "";
    
    var _array = _value;
    var _string = "";
    
    var _size = array_length(_array);
    var _i = 0;
    repeat(_size)
    {
        _string += string(_array[_i]);
        if (_i < _size-1) _string += ", ";
        ++_i;
    }
    
    return _string;
}