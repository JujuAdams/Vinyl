/// @param source
/// @param ...

function vinyl_random()
{
    switch(argument_count)
    {
        case 0: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_random()\n(Should be at least 1)"); break;
        
        case 1: return new __vinyl_pattern_random(argument[0]); break;
        case 2: return new __vinyl_pattern_random(argument[0], argument[1]); break;
        case 3: return new __vinyl_pattern_random(argument[0], argument[1], argument[2]); break;
        case 4: return new __vinyl_pattern_random(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __vinyl_pattern_random(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_random()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __vinyl_pattern_random() constructor
{
    __vinyl_pattern_common_construct();
    
    sources = array_create(argument_count, undefined);
    
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
        
        //Patternise and generate the sources
        var _i = 0;
        repeat(array_length(_sources))
        {
            var _source = __vinyl_patternize_source(sources[_i])
            _sources[@ _i] = _source.generate(false);
            ++_i;
        }
        
        //Generate our own player
        with(new __vinyl_player_random(_sources))
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
        return "Random " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_random(_sources) constructor
{
    __vinyl_player_common_construct();
    
    sources = _sources;
    
    var _i = 0;
    repeat(array_length(sources))
    {
        sources[_i].__parent = self;
        ++_i;
    }
    
    static reset = function()
    {
        __vinyl_player_common_reset();
        
        __index   = undefined;
        __current = undefined;
        
        var _i = 0;
        repeat(array_length(sources))
        {
            sources[_i].reset();
            ++_i;
        }
    }
    
    reset();
    
    static play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Figure out what to play
        __index = irandom(array_length(sources) - 1);
        __current = sources[__index];
        with(__current) play();
    }
    
    static get_position = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.get_position();
    }
    
    /// @param time
    static set_position = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.set_position(_time);
        }
    }
    
    static stop = function(_direct)
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __vinyl_trace("Stopping ", self);
            
            with(__current) stop(false);
            
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
        if (__started && !__finished && __VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) finish();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
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
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) tick();
                if (__current.__finished) finish();
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
        return "Random " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}