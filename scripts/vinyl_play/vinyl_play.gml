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
            var _instance = _source.generate(undefined);
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
    
    generate = function(_parent_buss)
    {
        //Pass on either our buss, or our parent's buss, to the new player
        var _buss = (buss != undefined)? buss : _parent_buss;
        
        //Generate a player
        with(new __vinyl_player_gm_audio(__source))
        {
            __vinyl_player_common_complete(other, _buss);
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
    __vinyl_player_common();
    
    __instance = undefined;
    __asset    = _asset;
    
    play = function()
    {
        //Grab our buss
        var _buss_struct = vinyl_buss_get(buss);
        if (!is_struct(_buss_struct)) _buss_struct = vinyl_master;
        
        //If we have some un-set values, figure them out
        var _parent_gain  = 1.0;
        var _parent_pitch = 1.0;
        if (is_struct(__parent))
        {
            _parent_gain  = __parent.__gain;
            _parent_pitch = __parent.__pitch;
        }
        
        if (__gain  == undefined) __gain  = gain *_parent_gain *_buss_struct.__gain;
        if (__pitch == undefined) __pitch = pitch*_parent_pitch*_buss_struct.__pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player (buss=\"", buss, "\", gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        //Play the audio asset
        __instance = audio_play_sound(__asset, 1, false);
        audio_sound_gain(__instance, __gain, 0.0);
        audio_sound_pitch(__instance, __pitch);
        
        //Set state
        __started = true;
        __finished = false;
    }
    
    stop = function()
    {
        if (!__stopping)
        {
            if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
            
            __stopping = true;
        }
    }
    
    stop_now = function()
    {
        if (!__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
            
            if (is_numeric(__instance) && audio_is_playing(__instance)) audio_stop_sound(__instance);
            
            __stopping = false;
            __finished = true;
            __instance = undefined;
        }
    }
    
    tick = function(_parent)
    {
        if (!__started && !__stopping)
        {
            play();
        }
        else
        {
            var _parent_gain  = 1.0;
            var _parent_pitch = 1.0;
            if (is_struct(__parent))
            {
                _parent_gain  = __parent.__gain;
                _parent_pitch = __parent.__pitch;
            }
            
            //Grab our buss
            var _buss_struct = vinyl_buss_get(buss);
            if (!is_struct(_buss_struct)) _buss_struct = vinyl_master;
            
            //If our internal gain is wrong, adjust that
            if (__gain != gain*_parent_gain*_buss_struct.__gain)
            {
                __gain = gain*_parent_gain*_buss_struct.__gain;
                if (is_numeric(__instance) && audio_is_playing(__instance)) audio_sound_gain(__instance, __gain, VINYL_STEP_DURATION);
            }
            
            //If our internal pitch is wrong, adjust that too
            if (__pitch != pitch*_parent_pitch*_buss_struct.__pitch)
            {
                __pitch = pitch*_parent_pitch*_buss_struct.__pitch;
                if (is_numeric(__instance) && audio_is_playing(__instance)) audio_sound_pitch(__instance, __pitch);
            }
            
            if (!__finished && __stopping)
            {
                //TODO - Fade out
                stop_now();
            }
            
            if (!__finished && (!is_numeric(__instance) || !audio_is_playing(__instance)))
            {
                stop_now();
            }
        }
    }
    
    toString = function()
    {
        return __vinyl_get_source_name(__asset);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player for ", self);
}