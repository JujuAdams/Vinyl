function __VinylGuiImportRealArray(_inString, _default)
{
    var _array = string_split(_inString, ",", true);
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _value = 0;
        
        try
        {
            _value = real(_value);
        }
        catch(_error)
        {
            _value = _default;
        }
        
        _array[@ _i] = _value;
        
        ++_i;
    }
    
    return _array;
}