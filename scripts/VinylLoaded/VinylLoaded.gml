/// @param alias

function VinylLoaded(_alias)
{
    return ds_map_exists(global.__vinylAssetMap, _alias);
}