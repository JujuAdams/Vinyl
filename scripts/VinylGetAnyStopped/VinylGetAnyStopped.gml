/// @param voiceOrArray

function VinylGetAnyStopped(_voiceOrArray)
{
    return not VinylGetAllPlaying(_voiceOrArray);
}