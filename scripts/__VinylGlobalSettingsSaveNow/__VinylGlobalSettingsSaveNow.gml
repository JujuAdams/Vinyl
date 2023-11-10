// Feather disable all

function __VinylGlobalSettingsSaveNow()
{
    static _editor = __VinylGlobalData().__editor;
    if (not __VinylGetEditorEnabled()) return;
    if (not _editor.__globalSettingDirty) return;
    
    _editor.__globalSettingDirty = false;
    
    var _string = json_stringify(_editor.__globalSettings, true);
    var _buffer = buffer_create(string_byte_length(_string), buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, _string);
    buffer_save(_buffer, __VinylGlobalSettingsGetPath());
    buffer_delete(_buffer);
}