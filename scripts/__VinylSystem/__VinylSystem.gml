// Feather disable all

#macro __VINYL_VERSION  "6.0.0"
#macro __VINYL_DATE     "2024-03-14"

#macro __VINYL_PROJECT_FILENAME  "VinylProject.json"

#macro __VINYL_RUNNING_FROM_IDE  (GM_build_type == "run")

enum __VINYL_SOUND_TYPE {
    __UNKNOWN,
    __WAD,
    __EXTERNAL_WAV,
    __EXTERNAL_OGG,
}

__VinylSystem();
function __VinylSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
    
    _system = {};
    with(_system)
    {
        if (__VINYL_RUNNING_FROM_IDE) global.vinylSystem = _system;
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VinylTick, [], -1));
    }
    
    return _system;
}