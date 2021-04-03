/// @param source

function VinylPlay(_in_source)
{
    var _source = _in_source;
    
    if (is_numeric(_source))
    {
        if (audio_exists(_source))
        {
            var _instance = new __VinyPlayerBasic(_source);
            ds_list_add(global.__vinylPlaying, _instance);
            return _instance;
        }
        else
        {
            __VinylError("Audio asset ", _source, " doesn't exist");
        }
    }
    else if (is_string(_source) || is_struct(_source))
    {
        if (is_string(_source))
        {
            _source = variable_struct_get(vinyl_lib, _source);
            if (!is_struct(_source))
            {
                __VinylError("Source \"", _in_source, "\" not found in library");
                return undefined;
            }
        }
        
        var _instanceof = instanceof(_source);
        if ((_instanceof == "__VinylPatternBasic" )
        ||  (_instanceof == "__VinylPatternLoop"  )
        ||  (_instanceof == "__VinylPatternRandom")
        ||  (_instanceof == "__VinylPatternQueue" )
        ||  (_instanceof == "__VinylPatternMulti" ))
        {
            var _instance = _source.generate(true);
            ds_list_add(global.__vinylPlaying, _instance);
            return _instance;
        }
        else
        {
            __VinylError("Invalid audio pattern (source=", _in_source, ")");
        }
    }
    else
    {
        __VinylError("Source datatype ", typeof(_source), " invalid");
    }
}