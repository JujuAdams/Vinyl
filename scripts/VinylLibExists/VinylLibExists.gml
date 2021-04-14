/// @param name

function VinylLibExists(_name)
{
    return ds_map_exists(global.__vinylLibraryMap, _name);
}