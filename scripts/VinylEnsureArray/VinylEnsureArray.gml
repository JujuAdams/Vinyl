/// @param value

function VinylEnsureArray(_value)
{
    return is_array(_value)? _value : [_value];
}