/// @param source
/// @param ...

function VinylQueue()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylQueue()\n(Should be at least 1)"); break;
        
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
    __VinylPatternCommonConstruct(__VinyInstanceQueue);
    
    __sources     = array_create(argument_count, undefined);
    __pops        = false;
    __dontPopLast = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = argument[_i];
        ++_i;
    }
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    #endregion
    
    
    
    #region Public Methods
    
    static PopSet = function(_state)
    {
        __pops = _state;
        return self;
    }
    
    static PopGet = function()
    {
        return __pops;
    }
    
    static DontPopLasttSet = function(_state)
    {
        __dontPopLast = _state;
        return self;
    }
    
    static DontPopLastGet = function()
    {
        return __dontPopLast;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param sources
function __VinyInstanceQueue(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __pops        = __pattern.__pops;
    __dontPopLast = __pattern.__dontPopLast;
    __sources     = __VinylInstancePatternizeAll(self, __pattern.__sources);
    __index       = undefined;
    
    //Create a backup of our sources to use when we reset this instance
    __sourcesCopy = array_create(array_length(__sources));
    array_copy(__sourcesCopy, 0, __sources, 0, array_length(__sources));
    
    __sourceStopping = [];
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_struct(__current)) return undefined;
        return __current.PositionGet();
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        if ((_time != undefined) && __started && !__finished && is_struct(__current))
        {
            __current.PositionSet(_time);
        }
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            with(__current) Stop();
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static Kill = function()
    {
        if (__started && !__finished && VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) Kill();
            ++_i;
        }
        
        //And also catch all of our stopping sources too
        var _i = 0;
        repeat(array_length(__sourceStopping))
        {
            with(__sourceStopping[_i]) Kill();
            ++_i;
        }
        
        __index    = undefined;
        __stopping = false;
        __finished = true;
        __current  = undefined;
    }
    
    
    
    static Choose = function(_index)
    {
        if ((_index < 0) || (_index >= array_length(__sources)))
        {
            __VinylError("Invalid index (", _index, "), must be from 0 to ", array_length(__sources) - 1, " inclusive (", self, ")");
        }
        else if (__index != _index)
        {
            __VinylTrace("Index set to ", _index, " (", self, ")");
            
            //Stop our current source and reference it in our stopping array
            __current.Stop();
            __sourceStopping[@ array_length(__sourceStopping)] = __current;
            
            //Change our index and start playing the appropriate source
            __index = _index;
            __current = __sources[__index];
            with(__current) __Play();
        }
    }
    
    static CurrentIndexGet = function()
    {
        return __index;
    }
    
    static CurrentInstanceGet = function()
    {
        return __current;
    }
    
    static CurrentStop = function()
    {
        var _instance = CurrentInstanceGet();
        if (_instance != undefined)
        {
            //Only try to stop this instance if it's actually an instance
            _instance.Stop();
        }
        else
        {
            __VinylTrace("No instance is currently playing (", self, ")");
        }
    }
    
    static Push = function(_source)
    {
        return Insert(_source, __loop? __index : array_length(__sources));
    }
    
    static Pop = function()
    {
        return Delete((__loop? __index : array_length(__sources)) - 1);
    }
    
    static Insert = function(_source, _index)
    {
        //Spin up a new instance to play
        var _instance = __VinylPatternizeSource(_source).__Play(false);
        
        if (__loop)
        {
            var _size = array_length(__sources);
            if (_size <= 0)
            {
                _index = 0;
            }
            else
            {
                _index = (_index + _size) mod _size;
            }
        }
        else
        {
            if ((_index < 0) || (_index > array_length(__sources)))
            {
                __VinylError("Invalid index (", _index, "), must be from 0 to ", array_length(__sources), " inclusive (", self, ")");
            }
        }
        
        array_insert(__sources, _index, _instance);
        if (_index <= __index) __index++;
        
        if (VINYL_DEBUG) __VinylTrace("Inserted instance into queue at position ", _index, ", is now ", self);
        
        return _instance;
    }
    
    static Delete = function(_index)
    {
        var _size = array_length(__sources);
        if (_size <= 0)
        {
            __VinylTrace("Cannot delete index ", _index, ", there are no queued instances (", self, ")");
        }
        else
        {
            if (__loop)
            {
                _index = (_index + _size) mod _size;
                
                array_delete(__sources, _index, 1);
                
                if (_index == __index)
                {
                    with(__current) Stop();
                    __sourceStopping[@ array_length(__sourceStopping)] = __current; 
                }
                
                if (_size <= 1)
                {
                    __index   = undefined;
                    __current = undefined;
                }
                else
                {
                    if (_index < __index)
                    {
                        __index = (__index - 1 + _size) mod _size;
                    }
                }
            }
            else
            {
                if ((_index < 0) || (_index >= array_length(__sources)))
                {
                    __VinylError("Invalid index (", _index, "), must be from 0 to ", array_length(__sources) - 1, " inclusive (", self, ")");
                }
                
                array_delete(__sources, _index, 1);
                
                if (_index == __index)
                {
                    with(__current) Stop();
                    __sourceStopping[@ array_length(__sourceStopping)] = __current; 
                }
                
                if (_size <= 1)
                {
                    __index   = undefined;
                    __current = undefined;
                }
                else
                {
                    if (_index < __index)
                    {
                        __index = (__index - 1 + _size) mod _size;
                    }
                }
            }
        }
        
        if (VINYL_DEBUG) __VinylTrace("Deleted instance at index ", _index, " from queue, is now ", self);
        
        return undefined;
    }
    
    static Clear = function()
    {
        with(__current) Stop();
        __sourceStopping[@ array_length(__sourceStopping)] = __current;
        
        __sources = [];
        
        if (VINYL_DEBUG) __VinylTrace("Cleared queue, is now ", self);
        
        return undefined;
    }
    
    #endregion
    
    
    
    #region Common Public Methods
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    static SourceGet         = __VinylInstanceSourceGet;
    static SourcesCountGet   = __VinylInstanceSourcesCountGet;
    static SourcesArrayGet   = __VinylInstanceSourcesArrayGet;
    static SourceFindIndex   = __VinylInstanceSourceFindIndex;
    static InstanceFindIndex = __VinylInstanceInstanceFindIndex;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __index   = undefined;
        __current = undefined;
        
        //Restore our sources backup
        sources = array_create(array_length(__sourcesCopy));
        array_copy(sources, 0, __sourcesCopy, 0, array_length(__sourcesCopy));
        
        //Reset our sources too
        var _i = 0;
        repeat(array_length(__sources))
        {
            __sources[_i].__Reset();
            ++_i;
        }
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Play the first source
        __index   = 0;
        __current = __sources[__index];
        with(__current) __Play();
    }
    
    static __Tick = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            //If we're not started and we're not stopping and we ain't finished, then play!
            __Play();
        }
        else
        {
            __VinylInstanceCommonTick();
            
            //Handle fade out
            if (__stopping && (current_time - __timeStopping > __timeFadeOut)) Kill();
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) __Tick();
                
                //Iterate over all our sources that are fading out 
                var _i = array_length(__sourceStopping)-1;
                repeat(array_length(__sourceStopping))
                {
                    var _source = __sourceStopping[_i];
                    
                    if (is_struct(_source))
                    {
                        if (_source.__finished)
                        {
                            __VinylArrayDelete(__sourceStopping, _i);
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
                    if (__current.__stopping || __current.__WillFinish())
                    {
                        if (__pops)
                        {
                            //Pop the current source so long as we're not on the last source in "loop on last" mode
                            if (!__loopOnLast || (array_length(__sources) > 1)) __VinylArrayDelete(__sources, __index);
                        }
                        else
                        {
                            ++__index;
                        }
                        
                        var _new_play = false;
                        
                        if (array_length(__sources) <= 0)
                        {
                            //Finish the queue if there are no sources left to play
                            Kill();
                        }
                        else if (__loop)
                        {
                            //If we're looping, wrap around to the start of the queue if necessary and play the next source
                            __index = __index mod array_length(__sources);
                            __current = sources[__index];
                            _new_play = true;
                        }
                        else if (__loopOnLast && (__index >= array_length(__sources)))
                        {
                            //If we're looping on the last source, loop that source
                            __index = array_length(__sources) - 1;
                            __current = __sources[__index];
                            _new_play = true;
                        }
                        else
                        {
                            //If we're *not* looping, only play the next source if we have something to play!
                            if (__index < array_length(__sources))
                            {
                                __current = __sources[__index];
                                _new_play = true;
                            }
                            else
                            {
                                Kill();
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
                                __sources[@ __index] = __current;
                            }
                            
                            with(__current) __Play();
                        }
                    }
                }
                else
                {
                    if (__current.__finished) Kill();
                }
            }
        }
    }
    
    static __WillFinish = function()
    {
        var _i = 0;
        repeat(array_length(__sources))
        {
            if (!__sources[_i].__WillFinish()) return false;
            ++_i;
        }
        
        var _i = 0;
        repeat(array_length(__sourceStopping))
        {
            if (!__sourceStopping[_i].__WillFinish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static toString = function()
    {
        return "Queue " + string(__sources);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance ", self);
}