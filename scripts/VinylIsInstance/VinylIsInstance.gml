/// @param value

function VinylIsInstance(_value)
{
    return (is_struct(_value) && (instanceof(_value) == "__VinylClassInstance"));
}