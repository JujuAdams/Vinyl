function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "basic";
    
    static toString = function()
    {
        if (__pattern == undefined)
        {
            return "<basic " + string(__id) + ">";
        }
        else
        {
            return "<basic " + string(__id) + " " + string(__pattern.__name) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
    }
    
    static __Instantiate = function(_pattern, _parentInstance, _vinylEmitter, _asset, _loop, _gain, _pitch, _pan)
    {
        __StateSetCommon(_pattern, _parentInstance, _vinylEmitter, _loop, _gain, _pitch, _pan);
        __child = __VinylPatternGet(_asset).__Play(self, __initialEmitter, _asset, __initialLoop, 1, 1, __pan);
    }
    
    static __Migrate = function()
    {
        __pattern = __VinylPatternGet(__pattern.__name);
        __MigrateCommon();
        
        if (__child != undefined) __child.__Migrate();
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__child == undefined) || !__child.__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            __TickCommon(_deltaTimeFactor);
            
            if (__child != undefined) //Instance can be destroyed in __TickCommon()
            {
                __child.__Tick(_deltaTimeFactor);
            }
            else
            {
                show_debug_message("!");
            }
        }
    }
}