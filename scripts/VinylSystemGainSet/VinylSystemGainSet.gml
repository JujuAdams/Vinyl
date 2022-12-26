/// Sets the system-wide gain for Vinyl
/// This number is NOT constrained by the VINYL_SYSTEM_HEADROOM value
/// 
/// @param gainDB

function VinylSystemGainSet(_gain)
{
    static _oldGain = undefined;
    if (_gain != _oldGain)
    {
        _oldGain = _gain;
        
        var _amplitude = __VinylGainToAmplitude(_gain + VINYL_SYSTEM_HEADROOM);
        audio_master_gain(_amplitude);
        
        __VinylTrace("Set system gain to ", _gain, " dB (VINYL_SYSTEM_HEADROOM=", _gain + VINYL_SYSTEM_HEADROOM, " db, resultant amplitude=", 100*_amplitude, "%)");
    }
}