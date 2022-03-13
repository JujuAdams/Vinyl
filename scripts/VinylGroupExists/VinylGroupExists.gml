/// @param name

function VinylGroupExists(_name)
{
    return variable_struct_exists(global.__vinylGroupsDict, _name);
}