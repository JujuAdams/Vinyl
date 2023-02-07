/// @param semitones

function VinylGlobalTransposeSet(_semitone)
{
    static _basicPoolPlaying = __VinylGlobalData().__basicPoolPlaying;
    
    if (_semitone != global.__vinylTransposeSemitones)
    {
        __VinylTrace("Setting transpose to ", _semitone, " semitones");
        global.__vinylTransposeSemitones = _semitone;
        
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