/// @param arrayA
/// @param arrayB

function array_union(_a, _b)
{
    var _new = array_create(array_length(_a), undefined);
    array_copy(_new, 0, _a, 0, array_length(_a));
    
    var _i = 0;
    repeat(array_length(_b))
    {
        var _value = _b[_i];
        if (!array_contains(_a, _value)) array_push(_new, _value);
        ++_i;
    }
    
    return _new;
}