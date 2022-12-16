/// @param gain

function VinylSystemGain(_gain)
{
	static _oldGain = undefined;
	if (_gain != _oldGain)
	{
		_oldGain = _gain;
		__VinylTrace("Set system gain to ", _gain, " dB");
		
		audio_master_gain(__VinylGainToAmplitudeCoeff(_gain + VINYL_HEADROOM));
	}
}