function __VinylGuiExportRangeableReal(_min, _max)
{
    if (_min == undefined) return "";
    if (_min == _max) return string_format(_min, 0, 3);
    return string_format(_min, 0, 3) + ", " + string_format(_max, 0, 3);
}