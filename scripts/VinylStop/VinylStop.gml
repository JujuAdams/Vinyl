/// @param soundInstance

function VinylStop(_sound_instance)
{
    if (VinylIsSoundInstance(_sound_instance))
    {
        _sound_instance.Stop(true);
    }
    else
    {
        __VinylTrace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
    }
}