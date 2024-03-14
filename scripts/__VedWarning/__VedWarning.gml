// Feather disable all

function __VedWarning()
{
    var _string = "Ved: Warning! ";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    _string += "          " + string(debug_get_callstack());
    
    show_debug_message(_string);
}