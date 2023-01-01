/// Returns the number of Vinyl playback instances currently active
/// This ONLY includes audio played using VinylPlay()
/// This does NOT include audio played using VinylPlaySimple()

function VinylSystemPlayingCountGet()
{
    return array_length(global.__vinylBasicPlaying);
}