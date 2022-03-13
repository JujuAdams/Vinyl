/// @param name

function VinylGroupCreate(_name)
{
    if (ds_map_exists(global.__vinylGroupsMap, _name))
    {
        __VinylError("Group \"", _name, "\" has already been defined");
        exit;
    }
    
    if (VINYL_DEBUG) __VinylTrace("Defined group \"", _name, "\"");
    
    var _group = new __VinylClassGroup(_name);
    
    global.__vinylGroupsMap[? _name] = _group;
    ds_list_add(global.__vinylGroupsList, _group);
    
    return _group;
}