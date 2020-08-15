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
        with(new __vinyl_player_random(_sources))
        {
            __pattern = other;
            reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    toString = function()
    {
        return "Random " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_random(_sources) constructor
{
    __vinyl_player_common_construct();
    
    __sources = _sources;
    
    var _i = 0;
    repeat(array_length(__sources))
    {
        __sources[_i].__parent = self;
        ++_i;
    }
    
    reset = function()
    {
        __vinyl_player_common_reset();
        
        __index   = undefined;
        __current = undefined;
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            __sources[_i].reset();
            ++_i;
        }
    }
    
    play = function()
    {
        __vinyl_player_common_play(false);
        
        if (__VINYL_DEBUG) __vinyl_trace("Playing (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ") ", self);
        
        //Figure out what to play
        __index = irandom(array_length(__sources) - 1);
        __current = __sources[__index];
        with(__current) play();
    }
    
    stop = function(_direct)
    {
        if (__VINYL_DEBUG) __vinyl_trace(self, " stopping");
        
        with(__current) stop(false);
        
        __stopping = true;
        __time_stopping = current_time;
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
        if (__started && !__finished && __VINYL_DEBUG) __vinyl_trace(self, " finished");
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) finish();
            ++_i;
        }
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    tick = function(_parent)
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
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) tick();
                if (__current.__finished) finish();
            }
        }
    }
    
    toString = function()
    {
        return "Random " + string(__sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}