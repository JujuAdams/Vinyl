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
    
    with(_system)
    {
        array_push(__logArray, {
            __createTime: current_time,
            __drawTime:   undefined,
            __string:     _string,
        });
        
        __logHistoricString += _string + "\n";
        if (string_byte_length(__logHistoricString) > 5000)
        {
            var _pos = string_pos("\n", __logHistoricString);
            __logHistoricString = string_delete(__logHistoricString, 1, _pos+1);
        }
    }
    
    __VedTrace(_string);
}