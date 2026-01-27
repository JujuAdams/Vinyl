// Feather disable all

/// Returns the BPM for a voice.
/// 
/// @param voice

function VinylGetBPM(_voice)
{
    return __VinylEnsureSoundVoice(_voice).__bpm;
}