/// @param soundInstance

function vinyl_stop(_sound_instance)
{
    var _instanceof = instanceof(_sound_instance);
    if ((_instanceof == "__vinyl_player_gm_audio")
    ||  (_instanceof == "__vinyl_player_loop")
    ||  (_instanceof == "__vinyl_player_random")
    ||  (_instanceof == "__vinyl_player_queue")
    ||  (_instanceof == "__vinyl_player_multi"))
    {
        _sound_instance.stop();
    }
    else
    {
        __vinyl_trace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
    }
}