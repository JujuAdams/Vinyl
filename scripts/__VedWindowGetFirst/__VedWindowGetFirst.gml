// Feather disable all

/// @param constructor

function __VedWindowGetFirst(_constructor)
{
    static _windowsArray = __VedSystem().__windowsArray;
    
    var _i = 0;
    repeat(array_length(_windowsArray))
    {
        if (is_instanceof(_windowsArray[_i], _constructor)) return _windowsArray[_i];
        ++_i;
    }
    
    return undefined;
}