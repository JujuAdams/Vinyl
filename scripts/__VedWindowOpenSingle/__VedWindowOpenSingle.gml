// Feather disable all

/// @param constructor

function __VedWindowOpenSingle(_constructor)
{
    static _windowsArray = __VedSystem().__windowsArray;
    
    var _first = __VedWindowGetFirst(_constructor);
    if (_first != undefined)
    {
        var _handle = _first.__handle;
        if (_handle != undefined) ImGui.SetWindowFocus(_handle);
        
        return _first;
    }
    else
    {
        return __VedWindowOpen(_constructor);
    }
}