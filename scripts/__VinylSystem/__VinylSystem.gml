#macro __VINYL_VERSION  "2.0.0"
#macro __VINYL_DATE     "2021/04/10"

__VinylTrace("Welcome to Vinyl by @jujuadams! This is version " + __VINYL_VERSION + ", " + __VINYL_DATE);



global.__vinylPlaying         = ds_list_create(); //TODO - Replace this with an array
global.__vinylGroupsList      = ds_list_create();
global.__vinylGroupsMap       = ds_map_create();
global.__vinylGlobalAssetGain = ds_map_create();
global.__vinylLibraryMap      = ds_map_create();



//Iterate over all audio assets and collect their start gain
var _i = 0;
repeat(9999)
{
    if (!audio_exists(_i)) break;
    global.__vinylGlobalAssetGain[? _i] = audio_sound_get_gain(_i);
    ++_i;
}



/// @param source
function __VinylPatternizeSource(_source)
{
    if (is_numeric(_source))
    {
        //TODO - Cache this
        return new __VinylPatternBasic(_source);
    }
    else
    {
        return _source;
    }
}

#region Utility

/// @param [value...]
function __VinylTrace()
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
function __VinylError()
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