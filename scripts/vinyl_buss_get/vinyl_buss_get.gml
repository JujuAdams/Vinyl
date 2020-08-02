/// @param bussName

function vinyl_buss_get(_name)
{
    return variable_struct_get(global.__vinyl_busses, _name);
}