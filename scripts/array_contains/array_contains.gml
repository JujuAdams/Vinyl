/// @param array
/// @param value

function array_contains(_array, _value)
{
    var _i = 0;
    repeat(array_length(_array))
    {
        if (_array[_i] == _value) return true;
        ++_i;
    }
    
    return false;
}