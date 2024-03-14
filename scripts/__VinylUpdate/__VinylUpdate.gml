// Feather disable all
function __VinylUpdate()
{
    static _system = __VinylSystem();
    
    if (not instance_exists(__VinylControllerObject))
    {
        instance_create_depth(0, 0, 0, __VinylControllerObject);
    }
    
    ++_system.__frame;
    var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
}
