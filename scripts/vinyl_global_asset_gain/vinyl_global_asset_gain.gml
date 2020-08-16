/// @param asset
/// @param gain

function vinyl_global_asset_gain(_asset, _gain)
{
    global.__vinyl_global_asset_gain[? _asset] = _gain;
}