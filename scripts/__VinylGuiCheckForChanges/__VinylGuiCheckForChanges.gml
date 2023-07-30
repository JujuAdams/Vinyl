function __VinylGuiCheckForChanges()
{
    static _globalData = __VinylGlobalData();
    
    var _changed = false;
    
    var _pattern     = _globalData.__guiPattern;
    var _guiCurrent  = _globalData.__guiCurrent;
    var _guiPrevious = _globalData.__guiPrevious;
    
    var _namesArray = variable_struct_get_names(_guiCurrent);
    var _i = 0;
    repeat(array_length(_namesArray))
    {
        var _name = _namesArray[_i];
        
        var _oldValue = _guiCurrent[$  _name];
        var _newValue = _guiPrevious[$ _name];
        
        if (_oldValue != _newValue)
        {
            __VinylTrace("Detected change in ", _pattern, " via GUI, ", _name);
            _guiPrevious[$ _name] = _newValue;
            _changed = true;
        }
        
        ++_i;
    }
    
    if (_changed)
    {
        __VinylTrace("Detected change in ", _pattern, " via GUI, updating");
        _pattern.__GuiImportStruct(_guiCurrent);
        _pattern.__GuiExportStruct(_guiCurrent);
    }
}