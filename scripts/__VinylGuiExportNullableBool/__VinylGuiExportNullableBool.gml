function __VinylGuiExportNullableBool(_value)
{
    if (_value == undefined) return 2;
    return _value? 0 : 1;
}