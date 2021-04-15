/// @param asset
/// @param pattern

function VinylLibAlias(_asset, _pattern)
{
    if (!VinylIsPattern(_pattern))
    {
        __VinylError("Pattern provided is invalid (", _pattern, ")");
    }
    
    if (ds_map_exists(global.__vinylLibraryMap, _asset))
    {
        __VinylTrace("Warning! Library pattern ", _asset, " (", audio_get_name(_asset), ") has already been defined");
    }
    
    if (VINYL_DEBUG) __VinylTrace("Defined library pattern ", _asset, " (", audio_get_name(_asset), ") as ", _pattern);
    
    global.__vinylLibraryMap[? _asset] = _pattern;
    return _pattern;
}