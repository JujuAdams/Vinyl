// Feather disable all

#macro __VINYL_VERSION  "6.0.0"
#macro __VINYL_DATE     "2024-03-14"

#macro __VINYL_PROJECT_FILENAME  "VinylProject.json"

#macro __VINYL_RUNNING_FROM_IDE  (GM_build_type == "run")
#macro __VINYL_NETWORKING_PORT  13587

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
    _system = {};
    
    with(_system)
    {
        __frame = 0;
        
        __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
        if (__VINYL_RUNNING_FROM_IDE) global.vinylSystem = self;
        
        if (VINYL_LIVE_EDIT)
        {
            __rpcDict = {};
            __sendBuffer = buffer_create(1024, buffer_grow, 1);
        }
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VinylUpdate, [], -1));
    }
    
    return _system;
}