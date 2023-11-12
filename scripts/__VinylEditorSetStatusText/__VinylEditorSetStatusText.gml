// Feather disable all

/// @param value
/// @param ...

function __VinylEditorSetStatusText()
{
    static _editor = __VinylGlobalData().__editor;
    
    var _string = "";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    _editor.__statusText        = _string;
    _editor.__statusTextLastSet = current_time;
}