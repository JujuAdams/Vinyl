// Feather disable all

/// @param gain

function VinylMasterSetGain(_gain)
{
    static _system = __VinylSystem();
    
    _gain = clamp(_gain, 0, 1);
    
    audio_master_gain(VINYL_MASTER_GAIN_BOOST*VINYL_MAX_GAIN*_gain);
    __masterGain = _gain;
}