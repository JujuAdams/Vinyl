/// @param alias

function VinylUnload(_alias)
{
    if (!VinylLoaded(_alias))
    {
        __VinylTrace("Cannot unload alias \"", _alias, "\" as it isn't currently load");
        exit;
    }
    
    ds_map_delete(global.__vinylAssetMap, _alias);
    if (VINYL_DEBUG) __VinylTrace("Unloaded \"", _alias, "\"");
}