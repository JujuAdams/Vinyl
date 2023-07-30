function __VinylGuiExportNullableReal(_value)
{
    if (_value == undefined) return "";
    return string_format(_value, 0, 3);
}