/// @param soundInstance

function vinyl_stop(_sound_instance)
{
    if (is_vinyl_sound_instance(_sound_instance))
    {
        _sound_instance.stop(true);
    }
    else
    {
        __vinyl_trace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
    }
}