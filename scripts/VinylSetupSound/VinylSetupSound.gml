// Feather disable all

/// @param sound
/// @param [gain=1]
/// @param [pitch=1]
/// @param [loop=false]
/// @param [mix=VINYL_DEFAULT_MIX]

function VinylSetupSound(_sound, _gain = undefined, _pitch = undefined, _loop = false, _mix = VINYL_DEFAULT_MIX)
{
    static _soundDict = __VinylSystem().__soundDict;
    
    __VINYL_HANDLE_GAINS
    __VINYL_HANDLE_PITCHES
    
    struct_get_from_hash(_soundDict, int64(_sound)).__UpdateSetup(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix);
}