/// @param sound

function __VinylAssetGet(_sound)
{
    return global.__vinylAssetDict[$ _sound] ?? global.__vinylAssetDict.fallback;
}