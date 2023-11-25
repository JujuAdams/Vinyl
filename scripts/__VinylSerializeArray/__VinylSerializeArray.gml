// Feather disable all

/// @param array
/// @param parent

function __VinylSerializeArray(_inputArray)
{
    var _outputArray = [];
    
    var _i = 0;
    repeat(array_length(_inputArray))
    {
        var _struct = {};
        _inputArray[_i].__Serialize(_struct);
        array_push(_outputArray, _struct);
        ++_i;
    }
    
    return _outputArray;
}