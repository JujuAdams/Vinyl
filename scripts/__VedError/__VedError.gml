function __VedError()
{
    var _string = "";
    
    var _i = 0
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message("Vinyl Editor " + __VED_VERSION + ": " + string_replace_all(_string, "\n", "\n             "));
    show_error("Vinyl Editor:\n" + _string + "\n ", true);
}