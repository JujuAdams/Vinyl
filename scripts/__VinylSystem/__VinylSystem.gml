// Feather disable all

#macro __VINYL_VERSION  "6.0.0"
#macro __VINYL_DATE     "2024-03-14"

#macro __VINYL_PROJECT_FILENAME  "vinyl.json"

#macro __VINYL_RUNNING_FROM_IDE  (GM_build_type == "run")
#macro __VINYL_NETWORKING_PORT  13587

enum __VINYL_SOUND_TYPE {
    __UNKNOWN,
    __WAD,
    __EXTERNAL_WAV,
    __EXTERNAL_OGG,
}

enum __VINYL_HLT_STATE
{
    __HEAD,
    __LOOP,
    __TAIL,
}

__VinylSystem();
function __VinylSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    _system = {};
    
    with(_system)
    {
        if (VINYL_DEBUG_SHOW_FRAMES) __frame = 0;
        
        __VinylTrace("Welcome to Vinyl! This is version ", __VINYL_VERSION, ", ", __VINYL_DATE);
        if (__VINYL_RUNNING_FROM_IDE) global.Vinyl = self;
        
        if (VINYL_LIVE_EDIT)
        {
            __rpcDict = {};
            __sendBuffer = buffer_create(1024, buffer_grow, 1);
            
            __voiceStructArray = [];
        }
        else
        {
            __voiceStructArray = undefined;
        }
        
        __soundDict   = {};
        __patternDict = {};
        __mixDict     = {};
        __mixArray    = [];
        
        __voiceStructUpdateArray = [];
        __voiceStructDict = {};
        
        var _defaultMix = (VINYL_DEFAULT_MIX == VINYL_NO_MIX)? undefined : VINYL_DEFAULT_MIX;
        var _soundDict = __soundDict;
        var _assetArray = asset_get_ids(asset_sound);
        var _i = 0;
        repeat(array_length(_assetArray))
        {
            var _sound = _assetArray[_i];
            struct_set_from_hash(_soundDict, int64(_sound), new __VinylClassPatternSound(_sound, 1, 1, 1, 1, false, _defaultMix));
            ++_i;
        }
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VinylUpdate, [], -1));
    }
    
    return _system;
}