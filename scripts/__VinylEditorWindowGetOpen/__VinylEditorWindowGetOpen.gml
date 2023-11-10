// Feather disable all

/// @param windowName

function __VinylEditorWindowGetOpen(_windowName)
{
    static _windowDict = __VinylGlobalData().__editor.__windowStates;
    if (not VinylEditorIsShowing()) return;
    
    return _windowDict[$ _windowName].__open;
}