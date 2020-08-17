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
    
    synchronize = false;
    loop = false;
    
    __sources = array_create(argument_count, undefined);
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __vinyl_patternize_source(argument[_i]);
        ++_i;
    }
    
    generate = function(_direct)
    {
        //Generate child players
        var _sources = array_create(array_length(__sources));
        var _i = 0;
        repeat(array_length(__sources))
        {
            _sources[@ _i] = __sources[_i].generate(false);
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
    
    toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_multi(_sources, _synchronize, _loop) constructor
{
    __vinyl_player_common_construct();
    
    synchronize = _synchronize;
    loop        = _loop;
    
    __sources = _sources;
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        if (is_struct(__sources[_i])) __sources[_i].__parent = self;
        ++_i;
    }
    
    reset = function()
    {
        __vinyl_player_common_reset();
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            if (is_struct(__sources[_i])) __sources[_i].reset();
            ++_i;
        }
    }
    
    play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) play();
            ++_i;
        }
    }
    
    get_position = function()
    {
        if (!__started || __finished) return undefined;
        
        var _any_valid = false;
        
        var _max_time = 0;
        var _i = 0;
        repeat(array_length(__sources))
        {
            var _time = __sources[_i].get_position();
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
    set_position = function(_time)
    {
        if ((_time != undefined) && __started && !__finished)
        {
            var _i = 0;
            repeat(array_length(__sources))
            {
                __sources[_i].set_position(_time);
                ++_i;
            }
        }
    }
    
    /// @param direct
    stop = function(_direct)
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            var _i = 0;
            repeat(array_length(__sources))
            {
                with(__sources[_i]) stop(false);
                ++_i;
            }
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    will_finish = function()
    {
        var _i = 0;
        repeat(array_length(__sources))
        {
            if (!__sources[_i].will_finish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    finish = function()
    {
        if (__VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) finish();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
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
                    repeat(array_length(__sources))
                    {
                        with(__sources[_i])
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
                        repeat(array_length(__sources))
                        {
                            __sources[_i].play();
                            ++_i;
                        }
                    }
                }
                else
                {
                    var _i = 0;
                    repeat(array_length(__sources))
                    {
                        with(__sources[_i])
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
                    repeat(array_length(__sources))
                    {
                        with(__sources[_i])
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
                    repeat(array_length(__sources))
                    {
                        with(__sources[_i])
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
    
    toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}