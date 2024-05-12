// Feather disable all

/// Fades out out a voice. Once a voice is set to fade out, it cannot be stopped.
/// 
/// @param voice
/// @param rateOfChange

function VinylFadeOut(_voice, _rateOfChange)
{
    __VinylEnsureSoundVoice(_voice).__FadeOut(max(0.001, _rateOfChange));
}