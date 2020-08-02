/// @param source
/// @param ...

function vinyl_multi()
{
    switch(argument_count)
    {
        case 0: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_multi()\n(Should be at least 1)"); break;
        
        case 1: return new __vinyl_pattern_multi(argument[0]); break;
        case 2: return new __vinyl_pattern_multi(argument[0], argument[1]); break;
        case 3: return new __vinyl_pattern_multi(argument[0], argument[1], argument[2]); break;
        case 4: return new __vinyl_pattern_multi(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __vinyl_pattern_multi(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_multi()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __vinyl_pattern_multi() constructor
{
    __vinyl_pattern_common();
    
    __sources = array_create(argument_count, undefined);
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __vinyl_patternize_source(argument[_i]);
        ++_i;
    }
    
    generate = function()
    {
        var _sources = array_create(array_length(__sources));
        var _i = 0;
        repeat(array_length(__sources))
        {
            _sources[@ _i] = __sources[_i].generate();
            ++_i;
        }
        
        return new __vinyl_player_multi(_sources);
    }
    
    toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_multi(_sources) constructor
{
    __vinyl_player_common();
    
    __sources = _sources;
    
    play = function()
    {
        if (__gain  == undefined) __gain  = gain;
        if (__pitch == undefined) __pitch = pitch;
        
        if (__VINYL_DEBUG) __vinyl_trace("Starting player (gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) play();
            ++_i;
        }
        
        __started = true;
        __finished = false;
    }
    
    stop = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) stop();
            ++_i;
        }
        
        __stopping = true;
    }
    
    stop_now = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) stop_now();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
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
            
            var _children_finished = true;
            
            var _i = 0;
            repeat(array_length(__sources))
            {
                with(__sources[_i])
                {
                    tick();
                    if (!__finished) _children_finished = false;
                }
                
                ++_i;
            }
            
            if (_children_finished) stop_now();
        }
    }
    
    toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}