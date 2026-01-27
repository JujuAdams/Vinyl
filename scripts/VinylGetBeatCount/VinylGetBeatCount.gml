// Feather disable all

/// Returns what number beat you're on in the track.
/// 
/// @param voice

function VinylGetBeatCount(_voice)
{
    return __VinylEnsureBeatTracker(_voice, false).__beatIndex;
}