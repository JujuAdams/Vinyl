/// Immediately stops all Vinyl playback instances
/// 
/// This function will NOT affect audio played by VinylPlaySimple()

function VinylStopAll()
{
    static _activeArray = __VinylGlobalData().__poolBasic.__activeArray;
    
    var _i = 0;
    repeat(array_length(_activeArray))
    {
        _activeArray[_i].__Stop();
        ++_i;
    }
}