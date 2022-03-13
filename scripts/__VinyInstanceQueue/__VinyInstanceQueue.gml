function __VinyInstanceQueue(_pattern) constructor
{
    __VINYL_INSTANCE_COMMON
    __VINYL_INSTANCE_COMMON_EXTENDED
    
    __pop     = __pattern.__pop;
    __popLast = __pattern.__popLast;
    __sources = __VinylInstanceInstantiateAll(self, __pattern.__sources);
    __index   = undefined;
    
    __sourceStopping = [];
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
    
    
    
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
    
    static IndexGet = function()
    {
        return __index;
    }
    
    static InstanceGet = function()
    {
        return __current;
    }
    
    static Push = function(_source)
    {
        return Insert(_source, array_length(__sources));
    }
    
    static Pop = function()
    {
        return Delete(array_length(__sources) - 1);
    }
    
    static Insert = function(_source, _index)
    {
        //Spin up a new instance to play
        var _instance = __VinylPatternInstantiate(self, __VinylPatternizeSource(_source));
        
        if ((_index < 0) || (_index > array_length(__sources)))
        {
            __VinylError("Invalid index (", _index, "), must be from 0 to ", array_length(__sources), " inclusive (", self, ")");
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
    
    static PopSet = function(_pop, _dontPopLast)
    {
        __pop     = _pop;
        __popLast = _dontPopLast;
        return self;
    }
    
    static PopGet = function()
    {
        return {
            pop : __pop,
            popLast : __popLast
        };
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __index   = undefined;
        __current = undefined;
        
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
    
    static __ReplayViaLoop = function()
    {
        if (!__started && !__stopping && !__finished)
        {
            __Play();
        }
        else
        {
            if (VINYL_DEBUG) __VinylTrace("Replaying ", self);
            
            __Reset();
            __Tick();
        }
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
            
            //Iterate over all our sources that are fading out 
            var _i = array_length(__sourceStopping)-1;
            repeat(array_length(__sourceStopping))
            {
                var _source = __sourceStopping[_i];
                    
                if (is_struct(_source))
                {
                    if (_source.__finished)
                    {
                        array_delete(__sourceStopping, _i, 1);
                    }
                    else
                    {
                        with(_source) if (__started && !__finished) __Tick();
                    }
                }
                
                --_i;
            }
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) __Tick();
                
                if (!__stopping)
                {
                    if (__current.__WillFinish())
                    {
                        if (__pop && (__popLast || (array_length(__sources) > 1)))
                        {
                            array_delete(__sources, __index, 1);
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
                        else
                        {
                            //Play the next source if we have something to play
                            if (__index < array_length(__sources))
                            {
                                if (__current != undefined) with(__current) Kill();
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
                                __current = __current.__Play(); //Play the instance
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
            if (!__sources[_i].__WillFinish() || !__sources[_i].__started) return false;
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
}