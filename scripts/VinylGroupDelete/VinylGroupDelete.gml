/// @param name

function VinylGroupDelete(_name)
{
    if (VinylGroupExists(_name))
    {
        if (VINYL_DEBUG) __VinylTrace("Deleted group \"", _name, "\"");
        
        var _group = global.__vinylGroupsMap[? _name];
        ds_map_delete(global.__vinylGroupsMap, _name);
        var _index = ds_list_find_index(global.__vinylGroupsList, _group);
        if (_index >= 0) ds_list_delete(global.__vinylGroupsList, _index);
    }
}