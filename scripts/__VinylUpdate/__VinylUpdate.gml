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
        ++__frame;
        var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
        
        var _i = 0;
        repeat(array_length(__voiceStructUpdateArray))
        {
            if (not __voiceStructUpdateArray[_i].__Update())
            {
                array_delete(__voiceStructUpdateArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
    }
}
