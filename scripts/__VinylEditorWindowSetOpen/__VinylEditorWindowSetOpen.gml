// Feather disable all

/// @param windowName
/// @param state

function __VinylEditorWindowSetOpen(_windowName, _state)
{
    static _windowDict = __VinylGlobalData().__editor.__windowStates;
    if (not VinylEditorIsShowing()) return;
    
    _windowDict[$ _windowName].__open = _state;
}