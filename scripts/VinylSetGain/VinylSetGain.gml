// Feather disable all

/// Sets the local gain for a voice. This is multipled with the sound/pattern gain set by the
/// corresponding setup function, the mix gain (if a mix is set for the voice), and the fade-out
/// gain to give the final playback gain for the voice.
/// 
/// @param voice

function VinylSetGain(_voice, _gain)
{
    __VinylEnsureSoundVoice(_voice).__SetLocalGain(_gain);
}