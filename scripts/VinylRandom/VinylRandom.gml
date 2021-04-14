/// @param source
/// @param ...

function VinylRandom()
{
    switch(argument_count)
    {
        case 0: __VinylError("Unsupported number of arguments (0) for VinylRandom()\n(Should be at least 1)"); break;
        
        case 1: return new __VinylPatternRandom(argument[0]); break;
        case 2: return new __VinylPatternRandom(argument[0], argument[1]); break;
        case 3: return new __VinylPatternRandom(argument[0], argument[1], argument[2]); break;
        case 4: return new __VinylPatternRandom(argument[0], argument[1], argument[2], argument[3]); break;
        case 5: return new __VinylPatternRandom(argument[0], argument[1], argument[2], argument[3], argument[4]); break
        
        default: __VinylError("Unsupported number of arguments (", argument_count, ") for VinylRandom()\n(Please add another case to the switch statement)"); break;
    }
}

/// @param source
/// @param ...
function __VinylPatternRandom() constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceRandom);
    
    __sources = array_create(argument_count, undefined);
    
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
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Random " + string(__sources);
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param sources
function __VinyInstanceRandom(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __sources = __VinylInstancePatternizeAll(self, __pattern.__sources);
    
    
    
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
            
            with(__current) Stop(false);
            
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
        __current  = undefined;
    }
    
    static CurrentIndexGet = function()
    {
        return __index;
    }
    
    static CurrentInstanceGet = function()
    {
        return __current;
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
            
            if (__current != undefined)
            {
                //Update the instance we're currently playing
                with(__current) __Tick();
                if (__current.__finished) Kill();
            }
        }
    }
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        __index   = undefined;
        __current = undefined;
        
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
        
        //Figure out what to play
        __index = irandom(array_length(__sources) - 1);
        __current = __sources[__index];
        with(__current) __Play();
    }
    
    static __WillFinish = function()
    {
        var _i = 0;
        repeat(array_length(__sources))
        {
            if (!sources[_i].__WillFinish()) return false;
            ++_i;
        }
        
        return true;
    }
    
    static toString = function()
    {
        return "Random " + string(__sources);
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance ", self);
}