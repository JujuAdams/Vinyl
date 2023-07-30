function __VinylGuiImportRangeableReal(_inString, _defaultMin, _defaultMax)
{
    _inString = string_trim(_inString);
    if (_inString == "") return undefined;
    
    var _array = string_split(_inString, ",", true);
    
    var _size = array_length(_array);
    if (_size == 1)
    {
        return __VinylGuiImportReal(_inString, 0.5*(_defaultMin + _defaultMax));
    }
    
    if (_size == 2)
    {
        return __VinylGuiImportRealArray(_inString, 0.5*(_defaultMin + _defaultMax));
    }
    
    return [_defaultMin, _defaultMax];
}