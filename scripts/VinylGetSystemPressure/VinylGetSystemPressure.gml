// Feather disable all

/// Returns how hard Vinyl is working to play audio. A value of `0` will be shown when Vinyl is not
/// performing any processing. A value of `1` indicates that Vinyl has reached saturation and audio
/// playback issues may occur.

function VinylGetSystemPressure()
{
    static _system = __VinylSystem();
    
    with(_system)
    {
        return max(ds_map_size(__voiceToStructMap), ds_map_size(__voiceToEmitterMap), array_length(__volatileEmitterArray)) / __VINYL_HIGH_PRESSURE_THRESHOLD;
    }
}