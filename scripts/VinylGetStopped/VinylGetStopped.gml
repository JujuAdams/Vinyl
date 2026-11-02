/// Returns `true` if *all* voices in the given array have been stopped. If any one voice is still
/// playing then this function will return `false`. If an empty array is provided then this
/// function will return `true`. If a voice is passed to this function directly (not in an array)
/// then this function will return if that particular voice has been stopped.
/// 
/// @param voiceOrArray

function VinylGetStopped(_voiceOrArray)
{
    return not VinylGetPlaying(_voiceOrArray);
}