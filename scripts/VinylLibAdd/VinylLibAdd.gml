/// @param name
/// @param pattern

function VinylLibAdd(_name, _pattern)
{
    if (!VinylIsPattern(_pattern))
    {
        __VinylError("Pattern provided is invalid (", _pattern, ")");
    }
    
    if (ds_map_exists(global.__vinylGroupsMap, _name))
    {
        __VinylTrace("Warning! Library \"", _name, "\" has already been defined");
    }
    
    if (VINYL_DEBUG) __VinylTrace("Defined library pattern \"", _name, "\" as ", _pattern);
    
    global.__vinylLibraryMap[? _name] = _pattern;
    return _pattern;
}