#region Internal Macro Definitions

#macro __VINYL_VERSION  "1.0.3"
#macro __VINYL_DATE     "2021/03/26"

#macro __VINYL_DEBUG  false

#macro vinyl_lib       global.__vinyl_library
#macro vinyl_library   global.__vinyl_library
#macro vinyl_master    (global.__vinyl_busses.master)

__vinyl_trace("Welcome to Vinyl by @jujuadams! This is version " + __VINYL_VERSION + ", " + __VINYL_DATE);

#endregion

global.__vinyl_playing           = ds_list_create(); //TODO - Replace this with an array
global.__vinyl_global_asset_gain = ds_map_create();
global.__vinyl_busses            = {};

vinyl_lib    = {};
vinyl_master = new __vinyl_class_buss();

//Iterate over all audio assets
var _i = 0;
repeat(9999)
{
    if (!audio_exists(_i)) break;
    global.__vinyl_global_asset_gain[? _i] = audio_sound_get_gain(_i);
    ++_i;
}
 
function vinyl_system_end_step()
{
    vinyl_master.tick();
    
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

function __vinyl_pattern_common_construct()
{
    buss_name = undefined;
    
    gain          = 1.0;
    gain_vary_min = 0.0;
    gain_vary_max = 0.0;
    
    pitch          = 1.0;
    pitch_vary_min = 0.0;
    pitch_vary_max = 0.0;
    
    time_fade_in  = undefined;
    time_fade_out = undefined;
}

function __vinyl_player_common_construct()
{
    buss_name = undefined;
    
    gain        = 1.0;
    gain_target = undefined;
    gain_rate   = 0.1;
    
    pitch        = 1.0;
    pitch_target = undefined;
    pitch_rate   = 0.1;
    
    time_fade_in  = 0.0;
    time_fade_out = 0.0;
    
    __buss    = undefined;
    __pattern = undefined;
    __parent  = undefined;
    
    __started       = false;
    __time_started  = -1;
    __stopping      = false;
    __time_stopping = -1;
    __finished      = false;
}

function __vinyl_player_common_reset()
{
    __started       = false;
    __time_started  = -1;
    __stopping      = false;
    __time_stopping = -1;
    __finished      = false;
    
    __buss  = undefined;
    __gain  = undefined;
    __pitch = undefined;
    
    if (__pattern != undefined)
    {
        if (__pattern.time_fade_in  != undefined) time_fade_in  = __pattern.time_fade_in;
        if (__pattern.time_fade_out != undefined) time_fade_out = __pattern.time_fade_out;
        
        //Randomise the gain/pitch as is appropriate
        gain  = __pattern.gain  + random_range(__pattern.gain_vary_min , __pattern.gain_vary_max );
        pitch = __pattern.pitch + random_range(__pattern.pitch_vary_min, __pattern.pitch_vary_max);
    }
}

/// @param useBuss
function __vinyl_player_common_play(_use_buss)
{
    finish();
    reset();
    
    //Set state
    __started = true;
    __time_started = current_time;
    
    __vinyl_player_common_tick(_use_buss);
}

/// @param useBuss
function __vinyl_player_common_tick(_use_buss)
{
    var _final_gain  = 1.0;
    var _final_pitch = 1.0;
    
    //Find our parent's gain, pitch, and buss
    if (is_struct(__parent))
    {
        _final_gain  *= __parent.__gain;
        _final_pitch *= __parent.__pitch;
        __buss = __parent.__buss;
    }
    else
    {
        //If we have no parent, find our own buss
        __buss = vinyl_buss_get(buss_name);
    }
    
    //If we want to factor in our buss' gain/pitch, do so here
    if (_use_buss)
    {
        if (!is_struct(__buss)) __buss = vinyl_master;
        _final_gain  *= __buss.__gain;
        _final_pitch *= __buss.__pitch;
    }
    
    //Calculate and apply the fade gain
    if (!__finished)
    {
        if (time_fade_in > 0)
        {
            _final_gain *= clamp((current_time - __time_started) / time_fade_in, 0.0, 1.0);
        }
        
        if (__stopping && (time_fade_out > 0))
        {
            _final_gain *= 1.0 - clamp((current_time - __time_stopping) / time_fade_out, 0.0, 1.0);
        }
    }
    
    //If our gain or pitch targets are undefined then we should set them!
    if (gain_target  == undefined) gain_target  = gain;
    if (pitch_target == undefined) pitch_target = pitch;
    
    //Tween to the gain/pitch target
    if (gain  != gain_target ) gain  += clamp(gain_target  - gain , -gain_rate , gain_rate );
    if (pitch != pitch_target) pitch += clamp(pitch_target - pitch, -pitch_rate, pitch_rate);
    
    //Set our final gain
    __gain  = gain*_final_gain;
    __pitch = pitch*_final_pitch;
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
        return new __vinyl_pattern_basic(_source);
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

/// @param array
/// @param index
function __vinyl_array_delete(_array, _index)
{
    var _copy_size = array_length(_array) - (_index+1);
    if ((_index < 0) || (_copy_size < 0)) throw "Index " + string(_index) + " is greater than maximum array index (" + string(array_length(_array)-1) + ")";
    
    var _new_array = array_create(_copy_size);
    array_copy(_new_array, 0, _array, _index+1, _copy_size);
    array_copy(_array, _index, _new_array, 0, _copy_size);
    array_resize(_array, array_length(_array)-1);
}

#endregion