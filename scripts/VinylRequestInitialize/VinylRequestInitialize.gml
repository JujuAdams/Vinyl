function VinylRequestInitialize()
{
    static _system = __VinylSystem();
    
    var _result = not _system.__initialized;
    _system.__initialized = true;
    
    if (_result)
    {
        audio_falloff_set_model(VINYL_FALLOFF_MODEL);
        
        //Known good default, albeit for 2D games
        audio_listener_set_orientation(0,   0, 0, 1,   0, -1, 0);
    }
    
    return _result;
}