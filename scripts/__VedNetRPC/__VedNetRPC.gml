// Feather disable all

/// @param name
/// @param argument0
/// @param argument1

function __VedNetRPC(_name)
{
    static _argumentArray = [];
    static _payload = {
        __type: "rpc",
        __name: undefined,
        __arguments: _argumentArray,
    };
    
    _payload.__name = _name;
    
    array_resize(_argumentArray, argument_count-1);
    var _i = 1;
    repeat(argument_count-1)
    {
        _argumentArray[_i-1] = argument[_i];
        ++_i;
    }
    
    __VedNetSendJSON(_payload);
}