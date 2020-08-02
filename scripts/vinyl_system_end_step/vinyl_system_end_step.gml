#region Internal Macro Definitions

#macro __VINYL_VERSION  "0.0.0"
#macro __VINYL_DATE     "2020/08/02"

#macro __VINYL_DEBUG  false

#macro vinyl_lib       global.__vinyl_library
#macro vinyl_library   global.__vinyl_library

#endregion

global.__vinyl_playing           = ds_list_create();
global.__vinyl_global_asset_gain = ds_map_create();
global.__vinyl_library           = {};

function vinyl_system_end_step()
{
    var _i = 0;
    repeat(ds_list_size(global.__vinyl_playing))
    {
        with(global.__vinyl_playing[| _i])
        {
            tick();
            
            if (__finished)
            {
                if (__VINYL_DEBUG) __vinyl_trace("Deleted ", self);
                ds_list_delete(global.__vinyl_playing, _i);
            }
            else
            {
                ++_i;
            }
        }
    }
}

function __vinyl_pattern_common()
{
    buss           = "master";
    
    gain           = 1.0;
    gain_vary_min  = 0.0;
    gain_vary_max  = 0.0;
    
    pitch          = 1.0;
    pitch_vary_min = 0.0;
    pitch_vary_max = 0.0;
    
    time_fade_in   = 0.0;
    time_fade_out  = 0.0;
}

function __vinyl_player_common()
{
    buss         = "master";
    
    gain         = 1.0;
    gain_target  = 1.0;
    gain_rate    = 0.1;
    
    pitch        = 1.0;
    pitch_target = 1.0;
    pitch_rate   = 0.1;
    
    __started  = false;
    __stopping = false;
    __finished = false;
    __gain     = undefined;
    __pitch    = undefined;
}

/// @param value
function __vinyl_get_source_name(_value)
{
    if (is_numeric(_value))
    {
        return audio_get_name(_value);
    }
    else
    {
        return string(_value);
    }
}

/// @param source
function __vinyl_patternize_source(_source)
{
    if (is_numeric(_source))
    {
        return new __vinyl_pattern_gm_audio(_source);
    }
    else
    {
        return _source;
    }
}

#region Utility

/// @param [value...]
function __vinyl_trace()
{
	var _string = "";
	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}

	show_debug_message(string_format(current_time, 8, 0) + " Vinyl: " + _string);

	return _string;
}

/// @param [value...]
function __vinyl_error()
{
	var _string = "";
    
	var _i = 0;
	repeat(argument_count)
	{
	    _string += string(argument[_i]);
	    ++_i;
	}
    
	show_error("Vinyl:\n" + _string + "\n ", false);
    
	return _string;
}

#endregion