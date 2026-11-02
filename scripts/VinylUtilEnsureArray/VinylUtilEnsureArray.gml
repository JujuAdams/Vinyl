/// Always returns an array. If the input value is not an array, the value will be placed in a new
/// array and that array will be returned. If the input value is an array, it will be passed
/// through this function without change.
/// 
/// @param value

function VinylUtilEnsureArray(_value)
{
    return is_array(_value)? _value : [_value];
}