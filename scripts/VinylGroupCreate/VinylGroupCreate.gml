/// @param name

function VinylGroupCreate(_name)
{
    if (variable_struct_exists(global.__vinylGroupsDict, _name))
    {
        __VinylError("Group \"", _name, "\" has already been defined");
        exit;
    }
    
    if (VINYL_DEBUG) __VinylTrace("Defined group \"", _name, "\"");
    
    var _group = new __VinylClassGroup(_name);
    
    global.__vinylGroupsDict[$ _name] = _group;
    array_push(global.__vinylGroupsArray, _group);
    
    return _group;
}