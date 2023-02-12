/// Returns the number of Vinyl playback instances currently active
/// This ONLY includes audio played using VinylPlay()
/// This does NOT include audio played using VinylPlaySimple()

function VinylSystemPlayingCountGet()
{
    static _activeArray = __VinylGlobalData().__poolBasic.__activeArray;
    return array_length(_activeArray);
}