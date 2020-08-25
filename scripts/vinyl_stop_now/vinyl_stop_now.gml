/// @param soundInstance

function vinyl_stop_now(_sound_instance)
{
    if (is_vinyl_sound_instance(_sound_instance))
    {
        _sound_instance.finish();
    }
    else
    {
        __vinyl_trace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
    }
}