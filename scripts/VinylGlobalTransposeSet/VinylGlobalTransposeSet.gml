/// @param semitones

function VinylGlobalTransposeSet(_semitone)
{
    static _globalData  = __VinylGlobalData();
    static _activeArray = _globalData.__poolBasic.__activeArray;
    
    if (_semitone != _globalData.__transposeSemitones)
    {
        __VinylTrace("Setting transpose to ", _semitone, " semitones");
        _globalData.__transposeSemitones = _semitone;
        
        var _i = 0;
        repeat(array_length(_activeArray))
        {
            with(_activeArray[_i])
            {
                if (__transposeUsing) __outputChanged = true;
            }
            
            ++_i;
        }
    }
}