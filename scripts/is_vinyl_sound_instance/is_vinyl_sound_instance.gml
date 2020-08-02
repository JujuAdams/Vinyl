/// @param soundInstance

function is_vinyl_sound_instance(_sound_instance)
{
    var _instanceof = instanceof(_sound_instance);
    if ((_instanceof == "__vinyl_player_gm_audio")
    ||  (_instanceof == "__vinyl_player_loop")
    ||  (_instanceof == "__vinyl_player_random")
    ||  (_instanceof == "__vinyl_player_queue")
    ||  (_instanceof == "__vinyl_player_multi"))
    {
        return true;
    }
    else
    {
        return false;
    }
}