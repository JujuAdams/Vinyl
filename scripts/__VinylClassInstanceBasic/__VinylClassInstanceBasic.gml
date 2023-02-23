function __VinylClassInstanceBasic() : __VinylClassInstanceCommon() constructor
{
    __StateReset();
    
    static __patternType = "basic";
    
    static toString = function()
    {
        if (__patternName == undefined)
        {
            return "<basic inst " + string(__id) + ">";
        }
        else
        {
            return "<basic inst " + string(__id) + " " + string(audio_get_name(__patternName)) + ">";
        }
    }
    
    static __StateReset = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __StateResetCommon();
    }
    
    static __Instantiate = function(_pattern, _parentInstance, _emitter, _sound, _loop, _gain, _pitch, _pan)
    {
        __StateSetCommon(_pattern, _parentInstance, _emitter, _loop, _gain, _pitch, _pan);
        
        __child = new __VinylClassInstanceGameMaker(); //TODO - Pool GameMaker instance wrappers
        __child.__Play(__gmEmitter, _sound, __loop, __gainOutput, __pitchOutput);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has child instance ", __child);
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        if (__child.__IsPlaying())
        {
            __TickCommon(_deltaTimeFactor);
            
            if (__child != undefined)
            {
                __child.__GainSet(__gainOutput);
                __child.__PitchSet(__pitchOutput);
            }
        }
        else
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
    }
}