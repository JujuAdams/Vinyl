/// @param bussName

function vinyl_buss_get(_name)
{
    if (_name == undefined) return undefined;
    return variable_struct_get(global.__vinyl_busses, _name);
}