// Feather disable all

/// @param voice

function VinylSetLocalGain(_voice, _gain)
{
    __VinylEnsureSoundVoice(_voice).__SetLocalGain(_gain);
}