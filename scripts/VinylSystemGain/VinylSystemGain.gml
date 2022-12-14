/// @param gain

function VinylSystemGain(_gain)
{
    audio_master_gain(__VinylGainToAmplitudeCoeff(_gain + VINYL_GAIN_MAXIMUM));
}