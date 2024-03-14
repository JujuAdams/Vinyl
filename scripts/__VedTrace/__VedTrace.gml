function __VedTrace()
{
    static _system = __VedSystem();
    
    if (VINYL_DEBUG_SHOW_FRAMES)
    {
        var _string = "Vinyl Editor fr." + string(_system.__frame) + ": ";
    }
    else
    {
        var _string = "Vinyl Editor: ";
    }
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
}