/// Returns if a Vinyl playback instance is paused
/// 
/// This function will return <undefined> if passed a label name as labels cannot have a "paused"
/// state in themselves. This function will further return <undefined> for audio played using
/// VinylPlaySimple()
/// 
/// @param vinylID

function VinylPausedGet()
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    return (is_struct(_instance) && is_numeric(_instance.__instance))? audio_is_paused(_instance.__instance) : undefined;
}