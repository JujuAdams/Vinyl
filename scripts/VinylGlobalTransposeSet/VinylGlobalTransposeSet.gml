/// Sets the global transposition state
/// 
/// Global transposition only affect Vinyl instances that have had their local transposition
/// state set by VinylTransposition(), even if that value is 0
/// 
/// @param semitones

function VinylGlobalTransposeSet(_semitone)
{
    static _globalData  = __VinylGlobalData();
    if (_semitone != _globalData.__transposeSemitones)
    {
        __VinylTrace("Setting transpose to ", _semitone, " semitones");
        _globalData.__transposeSemitones = _semitone;
    }
}