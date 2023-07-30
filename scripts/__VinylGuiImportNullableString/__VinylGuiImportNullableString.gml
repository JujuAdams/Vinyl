function __VinylGuiImportNullableString(_value)
{
    _value = string_trim(_value);
    
    return (_value == "")? undefined : _value;
}