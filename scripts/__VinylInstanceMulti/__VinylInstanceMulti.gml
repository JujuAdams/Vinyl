function __VinyInstanceMulti(_pattern) constructor
{
    __VINYL_INSTANCE_COMMON
    __VINYL_INSTANCE_COMMON_EXTENDED
    
    __synchronize    = __pattern.__synchronize;
    __sources        = __VinylInstanceInstantiateAll(self, __pattern.__sources);
    __blendParam     = __pattern.__blendParam;
    __blendAnimCurve = __pattern.__blendAnimCurve;
    __blendGains     = array_create(array_length(__sources), 0);
    
    __VinylBlendUpdate();
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
    
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished) return undefined;
        
        var _any_valid = false;
        
        var _max_time = 0;
        var _i = 0;
        repeat(array_length(__sources))
        {
            var _time = __sources[_i].PositionGet();
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
    static PositionSet = function(_time)
    {
        if ((_time != undefined) && __started && !__finished)
        {
            var _i = 0;
            repeat(array_length(__sources))
            {
                __sources[_i].PositionSet(_time);
                ++_i;
            }
        }
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            var _i = 0;
            repeat(array_length(__sources))
            {
                with(__sources[_i]) Stop(false);
                ++_i;
            }
            
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
        
        __stopping = false;
        __finished = true;
    }
    
    static SynchronizeSet = function(_state)
    {
        __synchronize = _state;
        return self;
    }
    
    static SynchronizeGet = function()
    {
        return __synchronize;
    }
    
    static ChildGet = function(_index)
    {
        return __sources[_index];
    }
    
    static BlendSet = function()
    {
        var _oldAnimCurve = __blendAnimCurve;
        
        var _param     = argument[0];
        var _animCurve = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : undefined;
        
        if (_oldAnimCurve != _animCurve)
        {
            var _channelCount = array_length(animcurve_get(_animCurve).channels);
            if (_channelCount < array_length(__sources)) __VinylError("Channel count in animation curve ", _animCurve, " (", _channelCount, ") is smaller than source count (", array_length(__sources));
            if (_channelCount > array_length(__sources)) __VinylTrace("Warning! Channel count in animation curve ", _animCurve, " (", _channelCount, ") is greater than source count (", array_length(__sources));
        }
        
        __blendParam     = _param;
        __blendAnimCurve = _animCurve;
        
        __VinylBlendUpdate();
        
        return self;
    }
    
    static BlendReset = function()
    {
        __blendParam     = undefined;
        __blendAnimCurve = undefined;
        __blendGains     = array_create(array_length(__sources), 0);
        
        return self;
    }
    
    static BlendGet = function()
    {
        return {
            parameter : __blendParam,
            animCurve : __blendAnimCurve,
        };
    }
    
    static BlendGainGet = function(_index)
    {
        if (!is_array(__blendGains)) return 0.0;
        if ((_index < 0) || (_index >= array_length(__blendGains))) __VinylError("Index provided (", _index, ") is invalid (0 <= index <= ", array_length(__blendGains) - 1, ")");
        return __blendGains[_index];
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        var _i = 0;
        repeat(array_length(__sources))
        {
            if (is_struct(__sources[_i])) __sources[_i].__Reset();
            ++_i;
        }
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        //Figure out what to play
        var _blendGains = __blendGains;
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i])
            {
                __inheritedBlendGain = _blendGains[_i];
                __Play();
            }
            
            ++_i;
        }
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
            
            //Figure out what to play
            var _blendGains = __blendGains;
            var _i = 0;
            repeat(array_length(__sources))
            {
                with(__sources[_i])
                {
                    __inheritedBlendGain = _blendGains[_i];
                    __ReplayViaLoop();
                }
                
                ++_i;
            }
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
            
            if (__synchronize)
            {
                var _finished = false;
                var _time = undefined;
                
                var _blendGains = __blendGains;
                var _i = 0;
                repeat(array_length(__sources))
                {
                    with(__sources[_i])
                    {
                        __inheritedBlendGain = _blendGains[_i];
                        __Tick(); //Update the instances we're currently playing
                        if (_time == undefined) _time = PositionGet() else PositionSet(_time);
                        if (__finished) _finished = true;
                    }
                        
                    ++_i;
                }
                
                if (_finished) Kill();
            }
            else
            {
                var _blendGains = __blendGains;
                var _finished = true;
                var _i = 0;
                repeat(array_length(__sources))
                {
                    with(__sources[_i])
                    {
                        __inheritedBlendGain = _blendGains[_i];
                        __Tick(); //Update the instances we're currently playing
                        if (!__finished) _finished = false;
                    }
                    
                    ++_i;
                }
            }
            
            if (_finished) Kill();
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
        
        return true;
    }
    
    static toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    #endregion
}