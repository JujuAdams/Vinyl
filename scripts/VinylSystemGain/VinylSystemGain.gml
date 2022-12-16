/// @param gain

function VinylSystemGain(_gain)
{
	static _oldGain = undefined;
	if (_gain != _oldGain)
	{
		_oldGain = _gain;
		
		var _amplitude = __VinylGainToAmplitudeCoeff(_gain + VINYL_SYSTEM_HEADROOM);
		audio_master_gain(_amplitude);
		
		__VinylTrace("Set system gain to ", _gain, " dB (inc. VINYL_SYSTEM_HEADROOM=", _gain + VINYL_SYSTEM_HEADROOM, " db)");
	}
}