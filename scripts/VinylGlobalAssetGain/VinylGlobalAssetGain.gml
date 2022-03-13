/// @param asset
/// @param gain

function VinylGlobalAssetGain(_asset, _gain)
{
    global.__vinylAssetGainDict[$ string(_asset)] = _gain;
}