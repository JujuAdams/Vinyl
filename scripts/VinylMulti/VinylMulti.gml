/// @param source
/// @param ...

function VinylMulti()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylMulti()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternMulti(argument[0]); break;
        case 2: return new __VinylPatternMulti(argument[0], argument[1]); break;
        case 3: return new __VinylPatternMulti(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternMulti(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylMulti()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternMulti() constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceMulti);
    
    __sources     = array_create(argument_count, undefined);
    __synchronize = false;
    
    //Copy input sources into the actual array
    var _i = 0;
    repeat(argument_count)
    {
        __sources[@ _i] = __VinylPatternizeSource(argument[_i]);
        ++_i;
    }
    
    
    
    #region Public Methods
    
    static SynchronizeSet = function(_state)
    {
        __synchronize = _state;
        return self;
    }
    
    static SynchronizeGet = function()
    {
        return __synchronize;
    }
    
    #endregion
    
    
    
    #region Common Public Methods
    
    static Play        = __VinylPatternPlay;
    static GainSet     = __VinylPatternGainSet;
    static GainGet     = __VinylPatternGainGet;
    static PitchSet    = __VinylPatternPitchSet;
    static PitchGet    = __VinylPatternPitchGet;
    static FadeTimeSet = __VinylPatternFadeTimeSet;
    static FadeTimeGet = __VinylPatternFadeTimeGet;
    
    static GroupAdd      = __VinylPatternGroupAdd;
    static GroupDelete   = __VinylPatternGroupDelete;
    static GroupClear    = __VinylPatternGroupClear;
    static GroupAssigned = __VinylPatternGroupAssigned;
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param sources
function __VinyInstanceMulti(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __synchronize = __pattern.__synchronize;
    __sources     = __VinylInstanceInstantiateAll(self, __pattern.__sources);
    
    
    
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
    
    static InstanceGet = function(_index)
    {
        return __sources[_index];
    }
    
    #endregion
    
    
    
    #region Common Public Methods
    
    static GainSet        = __VinylInstanceGainSet;
    static GainTargetSet  = __VinylInstanceGainTargetSet;
    static GainGet        = __VinylInstanceGainGet;
    static OutputGainGet  = __VinylInstanceOutputGainGet;
    static PitchSet       = __VinylInstancePitchSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static PitchTargetSet = __VinylInstancePitchTargetSet;
    static OutputPitchGet = __VinylInstanceOutputPitchGet;
    static FadeTimeSet    = __VinylInstanceFadeTimeSet;
    static FadeTimeGet    = __VinylInstanceFadeTimeGet;
    static PatternGet     = __VinylInstancePatternGet;
    static IsStopping     = __VinylInstanceIsStopping;
    static IsFinished     = __VinylInstanceIsFinished;
    
    static SourceGet         = __VinylInstanceSourceGet;
    static SourcesCountGet   = __VinylInstanceSourcesCountGet;
    static SourcesArrayGet   = __VinylInstanceSourcesArrayGet;
    static SourceFindIndex   = __VinylInstanceSourceFindIndex;
    static InstanceFindIndex = __VinylInstanceFindIndex;
    
    static GroupAdd      = __VinylInstanceGroupAdd;
    static GroupDelete   = __VinylInstanceGroupDelete;
    static GroupClear    = __VinylInstanceGroupClear;
    static GroupAssigned = __VinylInstanceGroupAssigned;
    
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
        var _i = 0;
        repeat(array_length(__sources))
        {
            with(__sources[_i]) __Play();
            ++_i;
        }
    }
    
    static __Tick = function()
    {
        //TODO - Much like queues, we should be checking to see if the loop source has changed and adjust accordingly
        
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
                
                var _i = 0;
                repeat(array_length(__sources))
                {
                    with(__sources[_i])
                    {
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
                var _finished = true;
                var _i = 0;
                repeat(array_length(__sources))
                {
                    with(__sources[_i])
                    {
                        __Tick(); //Update the instances we're currently playing
                        if (!__finished) _finished = false;
                    }
                    
                    ++_i;
                }
                
                if (_finished) Kill();
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
        
        return true;
    }
    
    static toString = function()
    {
        return "Multi " + string(__sources);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance ", self);
}