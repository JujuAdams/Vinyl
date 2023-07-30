function __VinylGuiImportReal(_inString, _default)
{
    var _value = 0;
    
    try
    {
        _value = real(_inString);
    }
    catch(_error)
    {
        _value = _default;
    }
    
    return _value;
}