// Feather disable all

/// @param target
/// @param loop
/// @param gain
/// @param pitch

function __VinylInterceptPlaySound(_target, _loop, _gain, _pitch)
{
    static _genData = __VinylGenPlay();
    if (not VINYL_LIVE_EDIT) return;
    
    struct_set_from_hash(_genData, int64(_target), method({
        __target: _target,
        __loop:   _loop,
        __gain:   _gain,
        __pitch,  _pitch,
    },
    function(_loop, _gain, _pitch)
    {
        return audio_play_sound(__target, 0, _loop ?? __loop, _gain*__gain, 0, _pitch*__pitch);
    }));
    
}