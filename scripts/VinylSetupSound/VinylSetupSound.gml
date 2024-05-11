// Feather disable all

/// Sets up a sound asset for playback with Vinyl. This is an optional function and any sound asset
/// without a Vinyl definition will be played at unity gain and on the default mix.
/// 
/// You should typically only call this function once on boot. Subsequent calls to this function
/// will only affect audio that is already playing if VINYL_LIVE_EDIT is set to <true>, and even
/// then calls to this function whilst audio is playing is expensive.
/// 
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
    
    if (_mix == VINYL_NO_MIX) _mix = undefined;
    
    struct_get_from_hash(_soundDict, int64(_sound)).__UpdateSetup(_gainMin, _gainMax, _pitchMin, _pitchMax, _loop, _mix);
}