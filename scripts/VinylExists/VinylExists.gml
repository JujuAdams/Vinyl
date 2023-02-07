/// Returns if the given Vinyl ID is for an active playback instance
/// 
/// This function will ALWAYS return <false> for audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylExists(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    return ds_map_exists(_idToInstanceDict, _id);
}