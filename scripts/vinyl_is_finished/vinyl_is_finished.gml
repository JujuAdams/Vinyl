/// @param soundInstance

function vinyl_is_finished(_sound_instance)
{
    if (is_vinyl_sound_instance(_sound_instance))
    {
        return _sound_instance.__finished;
    }
    else
    {
        __vinyl_trace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
        return false;
    }
}