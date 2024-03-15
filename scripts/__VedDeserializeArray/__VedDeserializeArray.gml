// Feather disable all

/// @param constructor
/// @param array

function __VedDeserializeArray(_constructor, _array)
{
    var _output = array_create(array_length(_array));
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _new = new _constructor();
        _output[_i] = _new;
        _new.__Deserialize(_array[_i]);
        ++_i;
    }
    
    return _output;
}