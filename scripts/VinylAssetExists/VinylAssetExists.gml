// Feather disable all
/// @param assetName

function VinylAssetExists(_assetName)
{
    static _projectSoundDict = __VinylGlobalData().__projectSoundDict;
    
    return variable_struct_exists(_projectSoundDict, _assetName);
}