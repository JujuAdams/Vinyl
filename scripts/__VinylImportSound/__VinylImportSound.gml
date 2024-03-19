// Feather disable all

function __VinylImportSound(_asset)
{
    if (is_string(_asset)) _asset = asset_get_index(_asset);
    
    if (not audio_exists(_asset))
    {
        __VinylWarning("Sound \"", _asset, "\" not recognised");
        return undefined;
    }
    
    return _asset;
}