/// @param soundInstance

function VinylStopNow(_sound_instance)
{
    if (VinylIsSoundInstance(_sound_instance))
    {
        _sound_instance.StopNow();
    }
    else
    {
        __VinylTrace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
    }
}