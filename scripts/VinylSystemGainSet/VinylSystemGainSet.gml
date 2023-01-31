/// Sets the system-wide gain for Vinyl
/// This number is NOT constrained by the VINYL_SYSTEM_MAX_GAIN value
/// 
/// @param gain

function VinylSystemGainSet(_gain)
{
    static _oldGain = undefined;
    if (_gain != _oldGain)
    {
        _oldGain = _gain;
        
        var _amplitude = VINYL_GAIN_DECIBEL_MODE? __VinylGainToAmplitude(_gain + VINYL_SYSTEM_MAX_GAIN) : VINYL_SYSTEM_MAX_GAIN*_gain;
        audio_master_gain(_amplitude);
        
        __VinylTrace("Set system gain to ", _gain, " (VINYL_SYSTEM_MAX_GAIN=", VINYL_SYSTEM_MAX_GAIN, ", resultant amplitude=", _amplitude, ")");
    }
}