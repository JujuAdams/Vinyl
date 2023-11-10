// Feather disable all

/// @param settingName

function __VinylGlobalSettingGet(_settingName)
{
    static _editor = __VinylGlobalData().__editor;
    if (not __VinylGetEditorEnabled()) return;
    
    var _globalSettings = _editor.__globalSettings;
    if (not variable_struct_exists(_globalSettings, _settingName))
    {
        __VinylError("Global setting \"", _settingName, "\" not recognised");
    }
    
    return _globalSettings[$ _settingName];
}