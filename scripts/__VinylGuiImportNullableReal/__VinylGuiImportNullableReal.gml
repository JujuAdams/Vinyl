function __VinylGuiImportNullableReal(_value, _default)
{
    _value = string_trim(_value);
    
    if (_value == "") return undefined;
    
    try
    {
        _value = real(_value);
    }
    catch(_error)
    {
        _value = _default;
    }
    
    return _value;
}