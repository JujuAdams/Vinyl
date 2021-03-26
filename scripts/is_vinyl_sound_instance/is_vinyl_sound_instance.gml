/// @param value

function is_vinyl_sound_instance(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__vinyl_player_basic" )
    ||  (_instanceof == "__vinyl_player_loop"  )
    ||  (_instanceof == "__vinyl_player_random")
    ||  (_instanceof == "__vinyl_player_queue" )
    ||  (_instanceof == "__vinyl_player_multi" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}