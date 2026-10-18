/// @param value

function VinylUtilEnsureArray(_value)
{
    return is_array(_value)? _value : [_value];
}