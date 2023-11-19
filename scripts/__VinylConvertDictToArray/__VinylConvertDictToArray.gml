// Feather disable all

function __VinylConvertDictToArray(_inputDict)
{
    var _outputArray = [];
    
    struct_foreach(_inputDict, method({
        __array: _outputArray,
    },
    function(_name, _value)
    {
        array_push(__array, _value);
    }));
    
    return _outputArray;
}