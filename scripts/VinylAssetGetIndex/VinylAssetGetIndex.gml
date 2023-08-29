// Feather disable all
function VinylAssetGetIndex(_name)
{
    static _useAssetDict     = __VinylGlobalData().__useProjectAssetDict
    static _projectAssetDict = __VinylGlobalData().__projectAssetDict
    
    if (_useAssetDict)
    {
        var _asset = _projectAssetDict[$ _name];
        return (_asset == undefined)? -1 : _asset.__asset;
    }
    else
    {
        return asset_get_index(_name);
    }
}