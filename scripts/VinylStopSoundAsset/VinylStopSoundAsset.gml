/// @param soundAsset

function VinylStopSoundAsset(_soundAsset)
{
    if (audio_exists(_soundAsset))
    {
        audio_stop_sound(_soundAsset);
    }
}