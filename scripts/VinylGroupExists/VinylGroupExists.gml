/// @param name

function VinylGroupExists(_name)
{
    return ds_map_exists(global.__vinylGroupsMap, _name);
}