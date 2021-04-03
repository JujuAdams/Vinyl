/// @param soundInstance

function VinylIsFinished(_sound_instance)
{
    if (VinylIsSoundInstance(_sound_instance))
    {
        return _sound_instance.__finished;
    }
    else
    {
        __VinylTrace("Warning! ", _sound_instance, " is not a Vinyl sound instance");
        return false;
    }
}