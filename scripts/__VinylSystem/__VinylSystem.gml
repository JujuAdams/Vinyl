#macro __VINYL_MAX_MIX_GROUP_GAIN  1

#macro __VINYL_PLAY_NONE  0
#macro __VINYL_PLAY_OMNI  1
#macro __VINYL_PLAY_AT    2
#macro __VINYL_PLAY_ON    3

__VinylSystem();

function __VinylSystem()
{
    static _system = (function()
    {
        with({})
        {
            if (GM_build_type == "run")
            {
                global.__Vinyl = self;
            }
            
            __initialized = false;
            
            __mixGroupArray = [];
            __soundDefMap = ds_map_create();
            
            __gmEmitterAndBusMap = ds_map_create();
            __gmEmitterAndBusArray = [];
            
            __masterGain = 1;
            __masterMute = false;
            
            __weakUpdateArray = [];
            __strongUpdateArray = [];
            
            time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
            {
                var _updateArray = __weakUpdateArray;
                var _i = 0;
                repeat(array_length(_updateArray))
                {
                    var _weakRef = _updateArray[_i];
                    if (weak_ref_alive(_weakRef))
                    {
                        _weakRef.ref.__Update();
                        ++_i;
                    }
                    else
                    {
                        array_delete(_updateArray, _i, 1);
                    }
                }
                
                var _updateArray = __strongUpdateArray;
                var _i = 0;
                repeat(array_length(_updateArray))
                {
                    if (not _updateArray[_i]())
                    {
                        array_delete(_updateArray, _i, 1);
                    }
                    else
                    {
                        ++_i;
                    }
                }
            },
            [], -1));
            
            return self;
        }
    })();
    
    return _system;
}