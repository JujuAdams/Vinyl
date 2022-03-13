/// @param gain

function VinylMasterGainSet(_gain)
{
    global.__vinylMasterGain = _gain;
    
    audio_master_gain(__VinylGainToAmplitudeCoeff(global.__vinylMasterGain + VINYL_GAIN_MAXIMUM));
}