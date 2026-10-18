/// @param voiceOrArray

function VinylGetAllStopped(_voiceOrArray)
{
    return not VinylGetAnyPlaying(_voiceOrArray);
}