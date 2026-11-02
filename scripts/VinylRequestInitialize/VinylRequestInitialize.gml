/// Requests initialization for Vinyl. This function will return `true` if Vinyl is able to be
/// initialized and `false` otherwise.
/// 
/// Example:
///     if (VinylRequestInitialize())
///     {
///         VinylDefineMixGroup(MIX_GROUP_SFX, "sfx", false);
///         VinylDefineSoundFromAssetTag("sfx", MIX_GROUP_SFX);
///     }

function VinylRequestInitialize()
{
    static _system = __VinylSystem();
    with(_system)
    {
        var _result = not __initialized;
        __initialized = true;
    
        if (_result)
        {
            audio_falloff_set_model(VINYL_FALLOFF_MODEL);
            
            //Known good default, albeit for 2D games
            VinylSetListener(0, 0, 0,   0, 0, 1,   0, 1, 0);
        }
        
        return _result;
    }
}