// Feather disable all

/// Returns whether a beat happened this Step for a playing voice.
/// 
/// @param voice

function VinylGetBeatThisStep(_voice)
{
    return __VinylEnsureBeatTracker(_voice, false).__beatThisStep;
}