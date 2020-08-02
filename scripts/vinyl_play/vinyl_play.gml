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
            _source = variable_struct_get(global.__vinyl_library, _source);
            if (!is_struct(_source))
            {
                __vinyl_error("Source \"", _in_source, "\" not found in library");
                return undefined;
            }
        }
        
        if (instanceof(_source) == "__vinyl_pattern_loop")
        {
            var _instance = _source.play();
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
    __vinyl_pattern_common();
    
    __source = _source;
    
    play = function()
    {
        return new __vinyl_player_gm_audio(__source);
    }
    
    toString = function()
    {
        return __vinyl_get_source_name(__source);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}

/// @param asset
function __vinyl_player_gm_audio(_asset) constructor
{
    __vinyl_player_common();
    
    __instance = undefined;
    __asset    = _asset;
    
    play = function()
    {
        if (__gain  == undefined) __gain  = gain;
        if (__pitch == undefined) __pitch = pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player ", self, " (gain=", __gain, ", pitch=", __pitch, ")");
        
        __instance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__instance, __gain, 0.0);
        audio_sound_pitch(__instance, __pitch);
        
        __started = true;
        __finished = false;
    }
    
    tick = function()
    {
        if (!__started)
        {
            play();
        }
        else
        {
            if (__gain  != gain ) __gain  = gain;
            if (__pitch != pitch) __pitch = pitch;
            
            if (!__finished && (!is_numeric(__instance) || !audio_is_playing(__instance)))
            {
                __finished = true;
                __instance = undefined;
                if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
            }
        }
    }
    
    toString = function()
    {
        return __vinyl_get_source_name(__asset);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}