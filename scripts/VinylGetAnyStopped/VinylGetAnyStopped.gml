/// Returns `true` if *any* voices in the given array have been stopped. Only if all voices are
/// playing will this function return `false`. If an empty array is provided then this function
/// will return `true`. If a voice is passed to this function directly (not in an array) then this
/// function will return if that particular voice has been stopped.
/// 
/// @param voiceOrArray

function VinylGetAnyStopped(_voiceOrArray)
{
    return not VinylGetAllPlaying(_voiceOrArray);
}