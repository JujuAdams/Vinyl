// Feather disable all

/// Attaches a BPM tracker to a Vinyl voice. This is not strictly necessary because beat tracker
/// functions will attach a tracker to a voice if one hasn't already been attached, but calling
/// `VinylAttachBeatTracker()` can help with some edge cases. This function should be called
/// immediately after playing some audio. If you set the optional `beginOnBeat` parameter to `true`
/// then `VinylGetBeatThisStep()` will return `true` on the same Step that this function is called.
/// 
/// @param voice
/// @param [beginOnBeat=false]

function VinylAttachBeatTracker(_voice, _beginOnBeat = false)
{
    return __VinylEnsureBeatTracker(_voice, _beginOnBeat);
}