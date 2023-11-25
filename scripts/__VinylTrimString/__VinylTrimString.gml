// Feather disable all

/// @param string
/// @param maxCharacters

function __VinylTrimString(_string, _maxCharacters)
{
    if (string_length(_string) > _maxCharacters)
    {
        return string_copy(_string, 1, _maxCharacters-3) + "...";
    }
    
    return _string;
}