// Feather disable all

/// @param soundName
/// @param loop
/// @param gain
/// @param pitch

if (VINYL_LIVE_EDIT) __VinylNetRPCRegister("__VinylOverwritePatternSound", __VinylOverwritePatternSound);
function __VinylOverwritePatternSound(_soundName, _loop, _gainArray, _pitchArray)
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
    if (_pattern == undefined)
    {
        var _pattern = new __VinylClassPatternSound(_sound, false, 1, 1, 1, 1);
        struct_set_from_hash(_genPatternData, int64(_sound), _pattern);
    }
    
    _pattern.__Update(_loop, _gainArray[0], _gainArray[1], _pitchArray[0], _pitchArray[1]);
    struct_set_from_hash(_genPlayData, int64(_sound), _pattern.__Play);
}