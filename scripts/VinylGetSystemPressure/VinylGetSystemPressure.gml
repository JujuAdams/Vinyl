// Feather disable all

function VinylGetSystemPressure()
{
    static _system = __VinylSystem();
    
    with(_system)
    {
        return max(ds_map_size(__voiceToStructMap), ds_map_size(__voiceToEmitterMap), array_length(__volatileEmitterArray)) / __VINYL_HIGH_PRESSURE_THRESHOLD;
    }
}