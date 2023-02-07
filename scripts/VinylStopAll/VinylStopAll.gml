/// Immediately stops all Vinyl playback instances
/// 
/// This function will NOT affect audio played by VinylPlaySimple()

function VinylStopAll()
{
    static _basicPoolPlaying = __VinylGlobalData().__basicPoolPlaying;
    
    var _i = 0;
    repeat(array_length(_basicPoolPlaying))
    {
        _basicPoolPlaying[_i].__Stop();
        ++_i;
    }
}