/// @param source

function vinyl_play(_source)
{
    if (is_numeric(_source))
    {
        if (audio_exists(_source))
        {
            return new __vinyl_class_gm_audio(_source, false);
        }
        else
        {
            __vinyl_error("Audio asset ", _source, " doesn't exist");
        }
    }
    else if (is_string(_source) || is_struct(_source))
    {
        __vinyl_error("Audio patterns not yet supported");
    }
    else
    {
        __vinyl_error("Source datatype ", typeof(_source), " invalid");
    }
}