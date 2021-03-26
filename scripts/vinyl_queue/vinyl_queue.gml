/// @param source
/// @param ...

function vinyl_queue()
{
    switch(argument_count)
    {
        case 0: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_queue()\n(Should be at least 1)"); break;
        
        case 1: return new __vinyl_pattern_queue(argument[0]); break;
        case 2: return new __vinyl_pattern_queue(argument[0], argument[1]); break;
        case 3: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2]); break;
        case 4: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __vinyl_pattern_queue(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __vinyl_error("Unsupported number of arguments (", argument_count, ") for vinyl_queue()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __vinyl_pattern_queue() constructor
{
    __vinyl_pattern_common_construct();
    
    sources       = array_create(argument_count, undefined);
    playing_index = undefined;
    loop          = false;
    pops          = false;
    loop_on_last  = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        sources[@ _i] = argument[_i];
        ++_i;
    }
    
    __source_stopping = [];
    
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
        with(new __vinyl_player_queue(_sources, loop, pops, loop_on_last))
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
        return "Queue " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created pattern ", self);
}

/// @param sources
function __vinyl_player_queue(_sources, _loop, _pops, _loop_on_last) constructor
{
    __vinyl_player_common_construct();
    
    sources       = _sources;
    playing_index = undefined;
    loop          = _loop;
    pops          = _pops;
    loop_on_last  = _loop_on_last;
    
    //Make sure all the sources we've been given have this player as their parent
    var _i = 0;
    repeat(array_length(sources))
    {
        sources[_i].__parent = self;
        ++_i;
    }
    
    //Create a backup of our sources to use when we reset this player
    __sources_copy = array_create(array_length(sources));
    array_copy(__sources_copy, 0, sources, 0, array_length(sources));
    
    __source_stopping = [];
    
    static reset = function()
    {
        __vinyl_player_common_reset();
        
        __index       = undefined;
        playing_index = __index;
        __current     = undefined;
        
        //Restore our sources backup
        sources = array_create(array_length(__sources_copy));
        array_copy(sources, 0, __sources_copy, 0, array_length(__sources_copy));
        
        //Reset our sources too
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
        
        //Play the first source
        __index       = 0;
        playing_index = __index;
        __current     = sources[__index];
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
    
    /// @param direct
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
        
        var _i = 0;
        repeat(array_length(__source_stopping))
        {
            if (!__source_stopping[_i].will_finish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static finish = function()
    {
        if (!__finished && __VINYL_DEBUG) __vinyl_trace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) finish();
            ++_i;
        }
        
        //And also catch all of our stopping sources too
        var _i = 0;
        repeat(array_length(__source_stopping))
        {
            with(__source_stopping[_i]) finish();
            ++_i;
        }
        
        playing_index = undefined;
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    static tick = function()
    {
        if (playing_index != __index)
        {
            __vinyl_trace("Playing index set to ", playing_index, " for ", self);
            
            //Stop our current source and reference it in our stopping array
            __current.stop();
            __source_stopping[@ array_length(__source_stopping)] = __current;
            
            //Change our index and start playing the appropriate source
            __index = playing_index;
            __current = sources[__index];
            with(__current) play();
        }
        
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
                
                //Iterate over all our sources that are fading out 
                var _i = array_length(__source_stopping)-1;
                repeat(array_length(__source_stopping))
                {
                    var _source = __source_stopping[_i];
                    
                    if (is_struct(_source))
                    {
                        if (_source.__finished)
                        {
                            __vinyl_array_delete(__source_stopping, _i);
                        }
                        else
                        {
                            with(_source) if (__started && !__finished) tick();
                        }
                    }
                    
                    --_i;
                }
                
                if (!__stopping)
                {
                    if (__current.__stopping || __current.will_finish())
                    {
                        if (pops)
                        {
                            //Pop the current source so long as we're not on the last source in "loop on last" mode
                            if (!loop_on_last || (array_length(sources) > 1)) __vinyl_array_delete(sources, __index);
                        }
                        else
                        {
                            ++__index;
                        }
                        
                        var _new_play = false;
                        
                        if (array_length(sources) <= 0)
                        {
                            //Finish the queue if there are no sources left to play
                            playing_index = undefined;
                            finish();
                        }
                        else if (loop)
                        {
                            //If we're looping, wrap around to the start of the queue if necessary and play the next source
                            __index = __index mod array_length(sources);
                            playing_index = __index;
                            __current = sources[__index];
                            _new_play = true;
                        }
                        else if (loop_on_last && (__index >= array_length(sources)))
                        {
                            //If we're looping on the last source, loop that source
                            __index = array_length(sources) - 1;
                            playing_index = __index;
                            __current = sources[__index];
                            _new_play = true;
                        }
                        else
                        {
                            //If we're *not* looping, only play the next source if we have something to play!
                            if (__index < array_length(sources))
                            {
                                playing_index = __index;
                                __current = sources[__index];
                                _new_play = true;
                            }
                            else
                            {
                                playing_index = undefined;
                                finish();
                            }
                        }
                        
                        if (_new_play)
                        {
                            //If we're playing a new source, check if it's a pattern
                            //Normally this won't happen, but we expose the sources array to the dev and they might try to play a pattern
                            __current = __vinyl_patternize_source(__current);
                            if (is_vinyl_pattern(__current))
                            {
                                __current = __current.generate(false); //Generate the source
                                sources[@ __index] = __current;
                            }
                            
                            with(__current) play();
                        }
                    }
                }
                else
                {
                    if (__current.__finished) finish();
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
        return "Queue " + string(sources);
    }
    
    if (__VINYL_DEBUG) __vinyl_trace("Created player ", self);
}