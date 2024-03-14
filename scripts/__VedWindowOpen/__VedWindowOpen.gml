// Feather disable all

/// @param constructor

function __VedWindowOpen(_constructor)
{
    static _windowsArray = __VedSystem().__windowsArray;
    var _window = new _constructor();
    array_push(_windowsArray, _window);
    return _window;
}