function __VedTrace()
{
    static _system = __VedSystem();
    
    var _string = "Ved: ";
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
}