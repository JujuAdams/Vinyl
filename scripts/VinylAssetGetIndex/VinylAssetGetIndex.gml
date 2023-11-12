// Feather disable all
/// @param assetName

function VinylAssetGetIndex(_assetName)
{
    static _projectSoundDict = __VinylGlobalData().__projectSoundDictionary;
    
    var _struct = _projectSoundDict[$ _assetName];
    return is_struct(_struct)? _struct.__soundID : -1;
}