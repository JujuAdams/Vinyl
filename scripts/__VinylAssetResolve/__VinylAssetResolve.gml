// Feather disable all
function __VinylAssetResolve(_asset)
{
    static _useAssetDict     = __VinylGlobalData().__useProjectAssetDict
    static _projectAssetDict = __VinylGlobalData().__projectAssetNameDict
    
    if (_useAssetDict)
    {
        var _assetStruct = _projectAssetDict[$ _asset];
        return (_assetStruct == undefined)? -1 : _assetStruct.__asset;
    }
    else
    {
        return _asset;
    }
}