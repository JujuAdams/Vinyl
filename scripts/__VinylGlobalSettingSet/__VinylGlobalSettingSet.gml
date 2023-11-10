// Feather disable all

/// @param settingName
/// @param value

function __VinylGlobalSettingSet(_settingName, _value)
{
    static _editor = __VinylGlobalData().__editor;
    if (not __VinylGetEditorEnabled()) return;
    
    var _globalSettings = _editor.__globalSettings;
    if (not variable_struct_exists(_globalSettings, _settingName))
    {
        __VinylError("Global setting \"", _settingName, "\" not recognised");
    }
    
    if (_globalSettings[$ _settingName] != _value)
    {
        _globalSettings[$ _settingName] = _value;
        __VinylGlobalSettingsSave();
    }
}