/// @param string

function __VinylDevError(_string)
{
    if (VINYL_RUNNING_FROM_IDE)
    {
        __VinylError(_string);
    }
    else
    {
        __VinylTrace(_string);
    }
}