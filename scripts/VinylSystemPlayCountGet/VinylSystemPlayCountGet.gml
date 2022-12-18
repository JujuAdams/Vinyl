/// Returns the number of Vinyl playback instances currently active

function VinylSystemPlayingCountGet()
{
    return array_length(global.__vinylPlaying);
}