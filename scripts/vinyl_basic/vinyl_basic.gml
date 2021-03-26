/// @param asset

function vinyl_basic(_asset)
{
    return __vinyl_patternize_source(_asset);
}

/// @param asset
function __vinyl_pattern_basic(_asset) constructor
{
    __vinyl_pattern_common_construct();
    
    asset = _asset;
    
    static generate = function(_direct)
    {
        //Generate a player
        with(new __vinyl_player_basic(asset))
        {
            __pattern = other;
            reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static buss_set = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static buss_get = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return __vinyl_get_source_name(asset);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern for ", self);
}

/// @param asset
function __vinyl_player_basic(_asset) constructor
{
    __vinyl_player_common_construct();
    
    __asset = _asset;
    
    static reset = function()
    {
        __vinyl_player_common_reset();
        
        __instance = undefined;
    }
    
    reset();
    
    static play = function()
    {
        __vinyl_player_common_play(true);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Play the audio asset
        __instance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__instance, __gain, 0.0);
        audio_sound_pitch(__instance, __pitch);
    }
    
    static get_position = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return undefined;
        return audio_sound_get_track_position(__instance);
    }
    
    /// @param time
    static set_position = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_numeric(__instance) && audio_is_playing(__instance))
        {
            audio_sound_set_track_position(__instance, _time);
        }
    }
    
    /// @param direct
    static stop = function(_direct)
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    static will_finish = function()
    {
        if (!__started || __finished || !is_numeric(__instance) || !audio_is_playing(__instance)) return true;
        return (((audio_sound_length(__instance) - audio_sound_get_track_position(__instance)) / __pitch) <= (VINYL_STEP_DURATION/1000));
    }
    
    static finish = function()
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
    
    static tick = function()
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
                var _asset_gain = global.__vinyl_global_asset_gain[? __asset];
                if (_asset_gain == undefined) _asset_gain = 1.0;
                
                //Update GM's sound instance
                audio_sound_gain(__instance, __gain*_asset_gain, VINYL_STEP_DURATION);
                audio_sound_pitch(__instance, __pitch);
            }
            
            if (!__finished)
            {
                //If our sound instance is somehow invalid, stop this player
                if (!is_numeric(__instance) || !audio_is_playing(__instance)) finish();
            }
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static buss_set = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static buss_get = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return __vinyl_get_source_name(__asset);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player for ", self);
}