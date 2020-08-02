#region Internal Macro Definitions

#macro __VINYL_VERSION  "0.0.0"
#macro __VINYL_DATE     "2020/08/02"

#macro __VINYL_DEBUG  true
    
#endregion

global.__vinyl_playing           = ds_list_create();
global.__vinyl_global_asset_gain = ds_map_create();

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
                __vinyl_trace("Deleted ", self);
                ds_list_delete(global.__vinyl_playing, _i);
            }
            else
            {
                ++_i;
            }
        }
    }
}

function __vinyl_sound_common()
{
    ds_list_add(global.__vinyl_playing, self);
    
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

/// @param asset
function __vinyl_class_gm_audio(_asset, _loop) constructor
{
    if (__VINYL_DEBUG) __vinyl_trace("Creating GM audio \"", audio_get_name(_asset), "\" (loop=", _loop, ")");
    
    __vinyl_sound_common();
    
    __instance = undefined;
    __asset    = _asset;
    __loop     = _loop;
    
    tick = function()
    {
        if (__gain  == undefined) __gain  = gain;
        if (__pitch == undefined) __pitch = pitch;
        
        if (!__started)
        {
            __started = true;
            
            __instance = audio_play_sound(__asset, 1, __loop);
            audio_sound_gain(__instance, __gain, 0.0);
            audio_sound_pitch(__instance, __pitch);
            
            if (__VINYL_DEBUG) __vinyl_trace("Started GM audio \"", audio_get_name(__asset), "\" (gain=", __gain, ", pitch=", __pitch, ", loop=", __loop, ")");
        }
        else
        {
            if (__gain  != gain ) __gain  = gain;
            if (__pitch != pitch) __pitch = pitch;
            
            if (!audio_is_playing(__instance))
            {
                __finished = true;
                if (__VINYL_DEBUG) __vinyl_trace("GM audio \"", audio_get_name(__asset), "\" finished");
            }
        }
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