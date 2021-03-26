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
    __vinyl_pattern_common_construct();
    
    sources     = array_create(argument_count, undefined);
    synchronize = false;
    loop        = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        sources[@ _i] = argument[_i];
        ++_i;
    }
    
    static generate = function(_direct)
    {
        var _sources = array_create(array_length(sources));
        
        //Patternise and generate sources
        var _i = 0;
        repeat(array_length(_sources))
        {
            var _source = __vinyl_patternize_source(sources[_i]);
            _sources[@ _i] = _source.generate(false);
            ++_i;
        }
        
        //Generate our own player
        with(new __vinyl_player_multi(_sources, synchronize, loop))
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
        return "Multi " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_multi(_sources, _synchronize, _loop) constructor
{
    __vinyl_player_common_construct();
    
    synchronize = _synchronize;
    loop        = _loop;
    
    sources = _sources;
    
    var _i = 0;
    repeat(array_length(sources))
    {
        if (is_struct(sources[_i])) sources[_i].__parent = self;
        ++_i;
    }
    
    static reset = function()
    {
        __vinyl_player_common_reset();
        
        var _i = 0;
        repeat(array_length(sources))
        {
            if (is_struct(sources[_i])) sources[_i].reset();
            ++_i;
        }
    }
    
    reset();
    
    static play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) play();
            ++_i;
        }
    }
    
    static get_position = function()
    {
        if (!__started || __finished) return undefined;
        
        var _any_valid = false;
        
        var _max_time = 0;
        var _i = 0;
        repeat(array_length(sources))
        {
            var _time = sources[_i].get_position();
            if (_time != undefined)
            {
                _any_valid = true;
                _max_time = max(_max_time, _time);
            }
            
            ++_i;
        }
        
        return _any_valid? _max_time : undefined;
    }
    
    /// @param time
    static set_position = function(_time)
    {
        if ((_time != undefined) && __started && !__finished)
        {
            var _i = 0;
            repeat(array_length(sources))
            {
                sources[_i].set_position(_time);
                ++_i;
            }
        }
    }
    
    /// @param direct
    static stop = function(_direct)
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            var _i = 0;
            repeat(array_length(sources))
            {
                with(sources[_i]) stop(false);
                ++_i;
            }
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    static will_finish = function()
    {
        var _i = 0;
        repeat(array_length(sources))
        {
            if (!sources[_i].will_finish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static finish = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) finish();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
    }
    
    static tick = function()
    {
        //TODO - Much like queues, we should be checking to see if the loop source has changed and adjust accordingly
        
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            play();
        }
        else
        {
            __vinyl_player_common_tick(false);
            
            //Handle fade out
            if (__stopping && (current_time - __time_stopping > time_fade_out)) finish();
            
            if (synchronize)
            {
                var _finished = false;
                var _time = undefined;
                
                if (loop)
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            tick(); //Update the instances we're currently playing
                            if (_time == undefined) _time = get_position() else set_position(_time);
                            if (will_finish()) _finished = true;
                        }
                        
                        ++_i;
                    }
                    
                    if (_finished)
                    {
                        var _i = 0;
                        repeat(array_length(sources))
                        {
                            sources[_i].play();
                            ++_i;
                        }
                    }
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            tick(); //Update the instances we're currently playing
                            if (_time == undefined) _time = get_position() else set_position(_time);
                            if (__finished) _finished = true;
                        }
                        
                        ++_i;
                    }
                    
                    if (_finished) finish();
                }
            }
            else
            {
                if (loop)
                {
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            tick(); //Update the instances we're currently playing
                            if (will_finish()) play();
                        }
                    
                        ++_i;
                    }
                }
                else
                {
                    var _finished = true;
                    var _i = 0;
                    repeat(array_length(sources))
                    {
                        with(sources[_i])
                        {
                            tick(); //Update the instances we're currently playing
                            if (!__finished) _finished = false;
                        }
                    
                        ++_i;
                    }
                    
                    if (_finished) finish();
                }
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
        return "Multi " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}