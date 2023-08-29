// Feather disable all
function __VinylAssetResolve(_asset)
{
    static _useAssetDict     = __VinylGlobalData().__useProjectAssetDict
    static _projectAssetDict = __VinylGlobalData().__projectAssetDict
    
    if (_useAssetDict)
    {
        var _asset = _projectAssetDict[$ _asset];
        return (_asset == undefined)? -1 : _asset.__asset;
    }
    else
    {
        return _asset;
    }
}