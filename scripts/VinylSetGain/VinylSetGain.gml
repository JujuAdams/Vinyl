// Feather disable all

/// Sets the local gain for a voice. This is multipled with the sound/pattern gain set by the
/// corresponding setup function, the mix gain (if a mix is set for the voice), and the fade-out
/// gain to give the final playback gain for the voice.
/// 
/// @param voice
/// @param gain
/// @param [rateOfChange]

function VinylSetGain(_voice, _gain, _rateOfChange = infinity)
{
    __VinylEnsureSoundVoice(_voice).__SetLocalGain(max(0, _gain), max(0.001, _rateOfChange));
}