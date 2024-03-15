// Feather disable all

/// @param value

function __VedLog()
{
    static _system = __VedSystem();
    
    var _string = "";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    array_push(_system.__logArray, {
        __createTime: current_time,
        __drawTime:   undefined,
        __string:     _string,
    });
    
    __VedTrace(_string);
    
}