// Feather disable all
function __VinylTick()
{
    static _system = __VinylSystem();
    
    ++_system.__frame;
    var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
}
