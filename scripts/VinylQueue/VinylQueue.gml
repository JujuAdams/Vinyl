/// @param source
/// @param ...

function VinylQueue()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylQueue()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternQueue(argument[0]); break;
        case 2: return new __VinylPatternQueue(argument[0], argument[1]); break;
        case 3: return new __VinylPatternQueue(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternQueue(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylQueue()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternQueue() constructor
{
    __VinylPatternCommonConstruct();
    
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
    
    static Play = function()
    {
        var _instance = __Play(true);
        ds_list_add(global.__vinylPlaying, _instance);
        return _instance;
    }
    
    static __Play = function(_direct)
    {
        var _sources = array_create(array_length(sources));
        
        //Patternise and generate sources
        var _i = 0;
        repeat(array_length(_sources))
        {
            var _source = __VinylPatternizeSource(sources[_i]);
            _sources[@ _i] = _source.__Play(false);
            ++_i;
        }
        
        //Generate our own player
        with(new __VinyPlayerQueue(_sources, loop, pops, loop_on_last))
        {
            __pattern = other;
            __Reset();
            if (_direct) buss_name = other.buss_name;
            return self;
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static BussSet = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static BussGet = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return "Queue " + string(sources);
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param sources
function __VinyPlayerQueue(_sources, _loop, _pops, _loop_on_last) constructor
{
    __VinylPlayerCommonConstruct();
    
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
    
    static __Reset = function()
    {
        __VinylPlayerCommonReset();
        
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
            sources[_i].__Reset();
            ++_i;
        }
    }
    
    __Reset();
    
    static __Play = function()
    {
        __VinylPlayerCommonPlay(false);
        
        if (__VINYL_DEBUG) __VinylTrace("Playing ", self, " (buss=\"", buss_name, "\", gain=", __gain, ", pitch=", __pitch, ")");
        
        //Play the first source
        __index       = 0;
        playing_index = __index;
        __current     = sources[__index];
        with(__current) __Play();
    }
    
    static GetPosition = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.GetPosition();
    }
    
    /// @param time
    static SetPosition = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.SetPosition(_time);
        }
    }
    
    static IsStopping = function()
    {
        return __stopping;
    }
    
    static IsFinished = function()
    {
        return __finished;
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (__VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            with(__current) Stop(false);
            
            __stopping = true;
            __time_stopping = current_time;
        }
    }
    
    static WillFinish = function()
    {
        var _i = 0;
        repeat(array_length(sources))
        {
            if (!sources[_i].WillFinish()) return false;
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(__source_stopping))
        {
            if (!__source_stopping[_i].WillFinish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static StopNow = function()
    {
        if (!__finished && __VINYL_DEBUG) __VinylTrace("Finished ", self);
        
        var _i = 0;
        repeat(array_length(sources))
        {
            with(sources[_i]) StopNow();
            ++_i;
        }
        
        //And also catch all of our stopping sources too
        var _i = 0;
        repeat(array_length(__source_stopping))
        {
            with(__source_stopping[_i]) StopNow();
            ++_i;
        }
        
        playing_index = undefined;
        
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    static __Tick = function()
    {
        if (playing_index != __index)
        {
            __VinylTrace("Playing index set to ", playing_index, " for ", self);
            
            //Stop our current source and reference it in our stopping array
            __current.Stop();
            __source_stopping[@ array_length(__source_stopping)] = __current;
            
            //Change our index and start playing the appropriate source
            __index = playing_index;
            __current = sources[__index];
            with(__current) __Play();
        }
        
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            __Play();
        }
        else
        {
            __VinylPlayerCommonTick(false);
            
            //Handle fade out
            if (__stopping && (current_time - __time_stopping > time_fade_out)) StopNow();
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) __Tick();
                
                //Iterate over all our sources that are fading out 
                var _i = array_length(__source_stopping)-1;
                repeat(array_length(__source_stopping))
                {
                    var _source = __source_stopping[_i];
                    
                    if (is_struct(_source))
                    {
                        if (_source.__finished)
                        {
                            __VinylArrayDelete(__source_stopping, _i);
                        }
                        else
                        {
                            with(_source) if (__started && !__finished) __Tick();
                        }
                    }
                    
                    --_i;
                }
                
                if (!__stopping)
                {
                    if (__current.__stopping || __current.WillFinish())
                    {
                        if (pops)
                        {
                            //Pop the current source so long as we're not on the last source in "loop on last" mode
                            if (!loop_on_last || (array_length(sources) > 1)) __VinylArrayDelete(sources, __index);
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
                            StopNow();
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
                                StopNow();
                            }
                        }
                        
                        if (_new_play)
                        {
                            //If we're playing a new source, check if it's a pattern
                            //Normally this won't happen, but we expose the sources array to the dev and they might try to play a pattern
                            __current = __VinylPatternizeSource(__current);
                            if (VinylIsPattern(__current))
                            {
                                __current = __current.__Play(false); //Generate the source
                                sources[@ __index] = __current;
                            }
                            
                            with(__current) __Play();
                        }
                    }
                }
                else
                {
                    if (__current.__finished) StopNow();
                }
            }
        }
    }
    
    //I don't trust GM not to mess up these functions if I put them in the common definition
    static BussSet = function(_buss_name)
    {
        buss_name = _buss_name;
        return self;
    }
    
    static BussGet = function()
    {
        return buss_name;
    }
    
    static toString = function()
    {
        return "Queue " + string(sources);
    }
    
    if (__VINYL_DEBUG) __VinylTrace("Created player ", self);
}