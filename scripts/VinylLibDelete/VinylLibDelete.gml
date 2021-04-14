/// @param name

function VinylLibDelete(_name)
{
    if (VinylGroupExists(_name))
    {
        if (VINYL_DEBUG) __VinylTrace("Deleted library pattern \"", _name, "\" (", global.__vinylLibraryMap[? _name], ")");
        
        ds_map_delete(global.__vinylLibraryMap, _name);
    }
}