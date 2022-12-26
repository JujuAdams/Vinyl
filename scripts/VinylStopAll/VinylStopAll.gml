/// Immediately stops all Vinyl playback instances
/// 
/// This function will NOT affect audio played by VinylPlaySimple()

function VinylStopAll()
{
    var _i = 0;
    repeat(array_length(global.__vinylPlaying))
    {
        global.__vinylPlaying[_i].__Stop();
        ++_i;
    }
}