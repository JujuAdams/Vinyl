/// @param source

function VinylLoop(_source)
{
    return new __VinylPatternLoop(_source);
}



/// @param intro
/// @param loop
/// @param outro
function __VinylPatternLoop(_source) constructor
{
    __VinylPatternCommonConstruct(__VinyInstanceLoop);
    
    __source = __VinylPatternizeSource(_source);
    
    
    
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
    
    
    
    #region Public Methods
    
    static SourceGet = function()
    {
        return __source;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static toString = function()
    {
        return "Loop [ " + string(__source) + " ]";
    }
    
    #endregion
    
    
    
    if (VINYL_DEBUG) __VinylTrace("Created pattern ", self);
}

/// @param intro
/// @param loop
/// @param outro
/// @param waitToPlayOutro
function __VinyInstanceLoop(_pattern) constructor
{
    __VinylInstanceCommonConstruct(_pattern);
    
    __source = __VinylPatternInstantiate(__pattern.__source);
    __VinylTrace("Set source to ", __source);
    
    
    #region Public Methods
    
    static PositionGet = function()
    {
        if (!__started || __finished || !is_struct(__source)) return undefined;
        return __source.PositionGet();
    }
    
    /// @param time
    static PositionSet = function(_time)
    {
        //TODO - Make this more accuracte by taking into account the length of the intro (if one exists)
        if ((_time != undefined) && __started && !__finished && is_struct(__source))
        {
            with(__source) PositionSet(_time);
        }
    }
    
    static Stop = function()
    {
        if (!__stopping && !__finished)
        {
            if (VINYL_DEBUG) __VinylTrace("Stopping ", self);
            
            __stopping = true;
            __timeStopping = current_time;
        }
    }
    
    static Kill = function()
    {
        if (__started && !__finished && VINYL_DEBUG) __VinylTrace("Killed ", self);
        
        with(__source) Kill();
        
        __stopping = false;
        __finished = true;
    }
    
    static InstanceGet = function()
    {
        return __source;
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
    
    static GroupAdd      = __VinylInstanceGroupAdd;
    static GroupDelete   = __VinylInstanceGroupDelete;
    static GroupClear    = __VinylInstanceGroupClear;
    static GroupAssigned = __VinylInstanceGroupAssigned;
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Reset = function()
    {
        __VinylInstanceCommonReset();
        
        if (__source != undefined) with(__source) __Reset();
    }
    
    static __Play = function()
    {
        __VinylInstanceCommonPlay();
        
        if (__source != undefined) with(__source) __Play();
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
            with(__source) __ReplayViaLoop();
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
            
            ////Handle fade out
            //if (__timeFadeOut > 0.0)
            //{
            //    if (__stopping && (current_time - __timeStopping > __timeFadeOut)) Kill();
            //}
            
            if (__source != undefined)
            {
                if (__source.__WillFinish())
                {
                    if (VINYL_DEBUG) __VinylTrace("Finished loop for ", self);
                    
                    if (__stopping)
                    {
                        Kill();
                    }
                    else
                    {
                        if (VINYL_DEBUG) __VinylTrace(self, " is replaying ", __source);
                        with(__source) __ReplayViaLoop();
                    }
                }
                
                with(__source) __Tick();
            }
        }
    }
    
    static __WillFinish = function()
    {
        if (__source == undefined) return true;
        with(__source) return __WillFinish();
    }
    
    static toString = function()
    {
        return "Loop [ " + string(__source) + " ]";
    }
    
    #endregion
    
    
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance ", self);
}