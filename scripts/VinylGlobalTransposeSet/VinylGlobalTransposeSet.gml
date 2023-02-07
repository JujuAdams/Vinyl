/// @param semitones

function VinylGlobalTransposeSet(_semitone)
{
    static _globalData       = __VinylGlobalData();
    static _basicPoolPlaying = _globalData.__basicPoolPlaying;
    
    if (_semitone != _globalData.__transposeSemitones)
    {
        __VinylTrace("Setting transpose to ", _semitone, " semitones");
        _globalData.__transposeSemitones = _semitone;
        
        var _i = 0;
        repeat(array_length(_basicPoolPlaying))
        {
            with(_basicPoolPlaying[_i])
            {
                if (__transposeUsing)
                {
                    __outputChanged = true;
                }
            }
            
            ++_i;
        }
    }
}