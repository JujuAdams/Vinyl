// Feather disable all

/// @param targetName
/// @param loop
/// @param gain
/// @param pitch

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("__VinylOverwritePlaySound", __VinylOverwritePlaySound);
function __VinylOverwritePlaySound(_targetName, _loop, _gain, _pitch)
{
    static _genData = __VinylGenPlay();
    if (not VINYL_LIVE_EDIT) return;
    
    var _target = asset_get_index(_targetName);
    if (not audio_exists(_target))
    {
        __VinylWarning("Target sound \"", _targetName, "\" not recognised");
        return;
    }
    
    struct_set_from_hash(_genData, int64(_target), method({
        __target: _target,
        __loop:   _loop,
        __gain:   _gain,
        __pitch:  _pitch,
    },
    function(_loop, _gain, _pitch)
    {
        return audio_play_sound(__target, 0,
                                _loop ?? __loop,
                                _gain*__VinylRandomRange(__gain[0], __gain[1]),
                                0,
                                _pitch*__VinylRandomRange(__pitch[0], __pitch[1]));
    }));
    
}