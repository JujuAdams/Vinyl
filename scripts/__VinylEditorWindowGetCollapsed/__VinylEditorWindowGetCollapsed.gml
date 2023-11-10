// Feather disable all

/// @param windowName

function __VinylEditorWindowGetCollapsed(_windowName)
{
    static _windowDict = __VinylGlobalData().__editor.__windowDict;
    if (not VinylEditorIsShowing()) return;
    
    return _windowDict[$ _windowName].__collapsed;
}