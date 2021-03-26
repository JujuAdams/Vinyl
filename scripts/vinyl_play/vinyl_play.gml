/// @param source

function vinyl_play(_in_source)
{
    var _source = _in_source;
    
    if (is_numeric(_source))
    {
        if (audio_exists(_source))
        {
            var _instance = new __vinyl_player_basic(_source);
            ds_list_add(global.__vinyl_playing, _instance);
            return _instance;
        }
        else
        {
            __vinyl_error("Audio asset ", _source, " doesn't exist");
        }
    }
    else if (is_string(_source) || is_struct(_source))
    {
        if (is_string(_source))
        {
            _source = variable_struct_get(vinyl_lib, _source);
            if (!is_struct(_source))
            {
                __vinyl_error("Source \"", _in_source, "\" not found in library");
                return undefined;
            }
        }
        
        var _instanceof = instanceof(_source);
        if ((_instanceof == "__vinyl_pattern_basic" )
        ||  (_instanceof == "__vinyl_pattern_loop"  )
        ||  (_instanceof == "__vinyl_pattern_random")
        ||  (_instanceof == "__vinyl_pattern_queue" )
        ||  (_instanceof == "__vinyl_pattern_multi" ))
        {
            var _instance = _source.generate(true);
            ds_list_add(global.__vinyl_playing, _instance);
            return _instance;
        }
        else
        {
            __vinyl_error("Invalid audio pattern (source=", _in_source, ")");
        }
    }
    else
    {
        __vinyl_error("Source datatype ", typeof(_source), " invalid");
    }
}