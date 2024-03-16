// Feather disable all

/// @param soundName

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("__VinylRemovePatternSound", __VinylRemovePatternSound);
function __VinylRemovePatternSound(_soundName)
{
    static _genPlayData    = __VinylGenPlay();
    static _genPatternData = __VinylGenPattern();
    
    if (not VINYL_LIVE_EDIT) return;
    
    var _sound = asset_get_index(_soundName);
    if (not audio_exists(_sound))
    {
        __VinylWarning("Target sound \"", _soundName, "\" not recognised");
        return;
    }
    
    var _pattern = struct_get_from_hash(_genPatternData, _sound);
    if (_pattern != undefined)
    {
        _pattern.__Update(false, 1, 1, 1, 1);
        struct_set_from_hash(_genPlayData, int64(_sound), undefined);
    }
}