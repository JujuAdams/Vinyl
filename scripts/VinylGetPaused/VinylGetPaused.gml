/// Returns if a Vinyl playback instance is paused
/// 
/// @param vinylID

function VinylGetPaused()
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    return (is_struct(_instance) && is_numeric(_instance.__instance))? audio_is_paused(_instance.__instance) : undefined;
}