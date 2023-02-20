/// Immediately stops all Vinyl playback instances
/// 
/// This function will NOT affect audio played by VinylPlaySimple()

function VinylStopAll()
{
    static _basicArray = __VinylGlobalData().__poolBasic.__activeArray;
    static _queueArray = __VinylGlobalData().__poolBasic.__activeArray;
    static _multiArray = __VinylGlobalData().__poolBasic.__activeArray;
    
    var _i = 0;
    repeat(array_length(_basicArray))
    {
        _basicArray[_i].__Stop();
        ++_i;
    }
    
    var _i = 0;
    repeat(array_length(_queueArray))
    {
        _queueArray[_i].__Stop();
        ++_i;
    }
    
    var _i = 0;
    repeat(array_length(_multiArray))
    {
        _multiArray[_i].__Stop();
        ++_i;
    }
}