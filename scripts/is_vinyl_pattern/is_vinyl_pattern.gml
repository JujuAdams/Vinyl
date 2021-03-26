/// @param value

function is_vinyl_pattern(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__vinyl_pattern_basic" )
    ||  (_instanceof == "__vinyl_pattern_loop"  )
    ||  (_instanceof == "__vinyl_pattern_random")
    ||  (_instanceof == "__vinyl_pattern_queue" )
    ||  (_instanceof == "__vinyl_pattern_multi" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}