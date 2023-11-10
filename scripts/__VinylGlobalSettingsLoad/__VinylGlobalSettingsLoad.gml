// Feather disable all

/// @param [immediate=false]

function __VinylGlobalSettingsLoad(_immediate = false)
{
    static _editor = __VinylGlobalData().__editor;
    if (not __VinylGetEditorEnabled()) return;
    
    if (file_exists(__VinylGlobalSettingsGetPath()))
    {
        var _buffer = buffer_load(__VinylGlobalSettingsGetPath());
        var _string = buffer_read(_buffer, buffer_text);
        buffer_delete(_buffer);
        
        try
        {
            _editor.__globalSettings = json_parse(_string);
            _editor.__globalSettingDirty = false;
        }
        catch(_error)
        {
            __VinylTrace("Warning! Failed to parse \"", __VinylGlobalSettingsGetPath(), "\" as JSON, global settings not loaded");
        }
    }
    else
    {
        __VinylTrace("Warning! Couldn't find \"", __VinylGlobalSettingsGetPath(), "\", global settings not loaded");
    }
    
    var _funcEnsure = function(_settingName, _value)
    {
        static _editor = __VinylGlobalData().__editor;
        
        var _globalSettings = _editor.__globalSettings;
        if (not variable_struct_exists(_globalSettings, _settingName))
        {
            _globalSettings[$ _settingName] = _value;
        }
    }
    
    _funcEnsure("username",                  "???");
    _funcEnsure("showGainsInDecibels",       false);
    _funcEnsure("showPitchInPercent",        false);
    _funcEnsure("maximumSnapshots",          10);
    _funcEnsure("refreshProjectOnRefocus",   true);
    _funcEnsure("defaultAutogenerateMacros", true);
    _funcEnsure("defaultMacroScriptName",    "__VinylGeneratedMacros");
}