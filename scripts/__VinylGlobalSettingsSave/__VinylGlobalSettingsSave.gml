// Feather disable all

/// @param [immediate=false]

function __VinylGlobalSettingsSave(_immediate = false)
{
    static _editor = __VinylGlobalData().__editor;
    if (not __VinylGetEditorEnabled()) return;
    
    _editor.__globalSettingDirty = true;
    if (_immediate) __VinylGlobalSettingsSaveNow();
}