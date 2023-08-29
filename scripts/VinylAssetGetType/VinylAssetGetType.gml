// Feather disable all
function VinylAssetGetType(_name)
{
    static _useAssetDict     = __VinylGlobalData().__useProjectAssetDict
    static _projectAssetDict = __VinylGlobalData().__projectAssetNameDict
    
    return (_useAssetDict && variable_struct_exists(_projectAssetDict, _name))? asset_sound : asset_get_type(_name);
}