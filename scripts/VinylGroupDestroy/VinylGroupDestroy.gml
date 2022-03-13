/// @param name

function VinylGroupDestroy(_name)
{
    if (VinylGroupExists(_name))
    {
        if (VINYL_DEBUG) __VinylTrace("Deleted group \"", _name, "\"");
        
        var _group = global.__vinylGroupsDict[$ _name];
        variable_struct_remove(global.__vinylGroupsDict, _name);
        
        var _i = 0;
        repeat(array_length(global.__vinylGroupsArray))
        {
            if (global.__vinylGroupsArray[_i] == _group)
            {
                array_delete(global.__vinylGroupsArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
    }
}