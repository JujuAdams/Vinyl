// Feather disable all

function __VinylGlobalSettingsGetPath()
{
    if (not __VinylGetEditorEnabled()) return;
    
    static _result = "VinylGlobalSettings.json";
    return _result;
}