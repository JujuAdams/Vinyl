/// @param source

function vinyl_play(_in_source)
{
    var _source = _in_source;
    
    if (is_numeric(_source))
    {
        if (audio_exists(_source))
        {
            var _instance = new __vinyl_player_gm_audio(_source);
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
        if ((_instanceof == "__vinyl_pattern_loop"  )
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

/// @param asset
function __vinyl_pattern_gm_audio(_source) constructor
{
    __vinyl_pattern_common_construct();
    
    __source = _source;
    
    generate = function(_direct)
    {
        //Generate a player
        with(new __vinyl_player_gm_audio(__source))
        {
            __pattern = other;
            reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    toString = function()
    {
        return __vinyl_get_source_name(__source);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern for ", self);
}

/// @param asset
function __vinyl_player_gm_audio(_asset) constructor
{
    __vinyl_player_common_construct();
    
    __asset = _asset;
    
    reset = function()
    {
        __vinyl_player_common_reset();
        
        __instance = undefined;
    }
    
    play = function()
    {
        __vinyl_player_common_play(true);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Play the audio asset
        __instance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__instance, __gain, 0.0);
        audio_sound_pitch(__instance, __pitch);
    }
    
    get_position = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return undefined;
        return audio_sound_get_track_position(__instance);
    }
    
    /// @param time
    set_position = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__instance) && audio_is_playing(__instance))
        {
            audio_sound_set_track_position(__instance, _time);
        }
    }
    
    /// @param direct
    stop = function(_direct)
    {
        if (!__stopping)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    will_finish = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return true;
        return (((audio_sound_length(__instance) - audio_sound_get_track_position(__instance)) / __pitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    finish = function()
    {
        if (__started && !__finished && __VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        if (!__finished)
        {
            if (is_numeric(__instance) && audio_is_playing(__instance)) audio_stop_sound(__instance);
            
            __stopping = false;
            __finished = true;
            __instance = undefined;
        }
    }
    
    tick = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            play();
        }
        else
        {
            __vinyl_player_common_tick(true);
            
            //Handle fade out
            if (__stopping && (current_time - __time_stopping > time_fade_out)) finish();
            
            if (is_numeric(__instance) && audio_is_playing(__instance))
            {
                //Update GM's sound instance
                audio_sound_gain(__instance, __gain, VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __pitch);
            }
            
            if (!__finished)
            {
                //If our sound instance is somehow invalid, stop this player
                if (!is_numeric(__instance) || !audio_is_playing(__instance)) finish();
            }
        }
    }
    
    toString = function()
    {
        return __vinyl_get_source_name(__asset);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player for ", self);
}