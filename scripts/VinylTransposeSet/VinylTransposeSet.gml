/// @param semitones

function VinylTransposeSet(_semitone)
{
    if (_semitone != global.__vinylTransposeSemitones)
    {
        __VinylTrace("Setting transpose to ", _semitone, " semitones");
        global.__vinylTransposeSemitones = _semitone;
        
        var _i = 0;
        repeat(array_length(global.__vinylPlaying))
        {
            with(global.__vinylPlaying[_i])
            {
                if (__pitchUsingSemitones)
                {
                    
                    __outputChanged = true;
                }
            }
            
            ++_i;
        }
    }
}