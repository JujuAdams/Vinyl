/// @param bussName

function VinylBussGet(_name)
{
    if (_name == undefined) return undefined;
    return variable_struct_get(global.__vinylBusses, _name);
}