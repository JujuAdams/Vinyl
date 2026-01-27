// Feather disable all

/// Returns how far from the nearest beat the track position is (in seconds). This value will be
/// positive if the next beat is in the future and negative if the nearest beat is in the past. If
/// you set the optional `runtime` parameter to `false` then the value returned will be from `-0.5`
/// to `0.5`.
/// 
/// @param voice
/// @param [realtime=true]

function VinylGetBeatDistance(_voice, _realtime = true)
{
    var _trackerStruct = __VinylEnsureBeatTracker(_voice);
    
    var _distance = _trackerStruct.__beatDistance;
    
    if (_realtime)
    {
        _distance *= 60 / (__VinylEnsureSoundVoice(_voice).__bpm ?? 1);
    }
    
    return _distance;
}