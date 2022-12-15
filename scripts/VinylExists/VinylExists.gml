/// @param value

function VinylExists(_value)
{
    return ds_map_exists(global.__vinylIdToInstanceDict, _value);
}