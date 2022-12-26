/// Returns if the given Vinyl ID is for an active playback instance
/// 
/// This function will ALWAYS return <false> for audio played using VinylPlaySimple()
/// 
/// @param vinylID

function VinylExists(_id)
{
    return ds_map_exists(global.__vinylIdToInstanceDict, _id);
}