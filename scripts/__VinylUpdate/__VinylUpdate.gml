// Feather disable all
function __VinylUpdate()
{
    static _system = __VinylSystem();
    
    if (VINYL_LIVE_EDIT)
    {
        if (not instance_exists(__VinylControllerObject))
        {
            instance_create_depth(0, 0, 0, __VinylControllerObject);
        }
    }
    
    with(_system)
    {
        if (VINYL_DEBUG_SHOW_FRAMES) __frame++;
        
        var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
        
        var _array = __voiceUpdateArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            if (not _array[_i].__Update(_deltaTimeFactor))
            {
                array_delete(_array, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        var _array = __mixArray;
        var _i = 0;
        repeat(array_length(_array))
        {
            _array[_i].__Update();
            ++_i;
        }
        
        var _array = __voiceCleanUpArray;
        var _length = array_length(_array);
        if (_length > 0)
        {
            var _index = (__cleanUpIndex + 1) mod _length;
            
            if (not audio_is_playing(_array[_index]))
            {
                //FIXME - Replace with struct_remove_from_hash() when that is made available
                struct_set_from_hash(__voiceStructDict, int64(_array[_index]), undefined);
                array_delete(_array, _index, 1);
            }
            
            __cleanUpIndex = _index;
        }
    }
}
