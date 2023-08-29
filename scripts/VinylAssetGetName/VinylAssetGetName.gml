// Feather disable all
function VinylAssetGetName(_asset)
{
    static _useAssetDict     = __VinylGlobalData().__useProjectAssetDict
    static _projectAssetDict = __VinylGlobalData().__projectAssetDict
    
    if (_useAssetDict)
    {
        var _projectAsset = _projectAssetDict[$ _asset];
        if (_projectAsset != undefined) return _projectAsset.__name;
    }
    
    return audio_get_name(_asset);
}