function __VinyInstanceLoop(_pattern) constructor
{
    __VINYL_INSTANCE_COMMON
    
    __source = __VinylPatternInstantiate(self, __pattern.__source);
    __VinylTrace("Set source to ", __source);
    
    __Reset();
    
    if (VINYL_DEBUG) __VinylTrace("Created instance for ", self);
    
    
    
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
}