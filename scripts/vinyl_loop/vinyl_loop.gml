/// @param source

function vinyl_loop(_source)
{
    return new __vinyl_pattern_loop(_source);
}

/// @param source
function __vinyl_pattern_loop(_source) constructor
{
    __vinyl_pattern_common();
    
    __source = __vinyl_patternize_source(_source);
    
    play = function()
    {
        return new __vinyl_player_loop(__source.play());
    }
    
    toString = function()
    {
        return "Loop {" + __vinyl_get_source_name(__source) + "}";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param source
function __vinyl_player_loop(_source) constructor
{
    __vinyl_player_common();
    
    __source = _source;
    
    play = function()
    {
        if (__gain  == undefined) __gain  = gain;
        if (__pitch == undefined) __pitch = pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player ", self, " (gain=", __gain, ", pitch=", __pitch, ")");
        
        with(__source)
        {
            play();
        }
        
        __started = true;
        __finished = false;
    }
    
    stop = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        __stopping = true;
    }
    
    stop_now = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        with(__source) stop_now();
        
        __stopping = false;
        __finished = true;
        __instance = undefined;
    }
    
    tick = function()
    {
        if (!__started && !__stopping)
        {
            play();
        }
        else
        {
            if (__gain  != gain ) __gain  = gain;
            if (__pitch != pitch) __pitch = pitch;
            
            var _children_stopping = true;
            var _children_finished = true;
            
            with(__source)
            {
                tick();
                if (!__stopping) _children_stopping = false;
                if (!__finished) _children_finished = false;
            }
            
            if (_children_finished)
            {
                if (!__stopping)
                {
                    if (__VINYL_DEBUG) __vinyl_trace(self, ": source finished, restarting");
                    with(__source) play();
                }
                else
                {
                    stop_now();
                }
            }
        }
    }
    
    toString = function()
    {
        return "Loop {" + __vinyl_get_source_name(__source) + "}";
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}