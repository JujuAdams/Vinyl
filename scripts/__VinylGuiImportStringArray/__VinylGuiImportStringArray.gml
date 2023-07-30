function __VinylGuiImportStringArray(_inString)
{
    var _array = string_split(_inString, ",", true);
    
    var _i = 0;
    repeat(array_length(_array))
    {
        _array[@ _i] = string_trim(_array[_i]);
        ++_i;
    }
    
    return _array;
}