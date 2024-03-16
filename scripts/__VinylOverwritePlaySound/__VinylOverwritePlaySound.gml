// Feather disable all

/// @param targetName

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("__VinylRemovePlaySound", __VinylRemovePlaySound);
function __VinylRemovePlaySound(_targetName)
{
    static _genData = __VinylGenPlay();
    if (not VINYL_LIVE_EDIT) return;
    
    var _target = asset_get_index(_targetName);
    if (not audio_exists(_target))
    {
        __VinylWarning("Target sound \"", _targetName, "\" not recognised");
        return;
    }
    
    struct_set_from_hash(_genData, int64(_target), undefined);
}