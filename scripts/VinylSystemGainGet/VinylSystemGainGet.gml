function VinylSystemGainGet()
{
    return audio_get_master_gain(0) / VINYL_MAX_GAIN;
}