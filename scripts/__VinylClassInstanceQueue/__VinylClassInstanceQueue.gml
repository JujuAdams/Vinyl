function __VinylClassInstanceQueue() : __VinylClassInstanceCommon() constructor
{
    static __patternType = "queue";
    
    static toString = function()
    {
        return "<queue inst " + string(__id) + ">";
    }
    
    
    
    static __Play = function(_emitter, _assetArray, _loop, _gain, _pitch, _pan)
    {
        //TODO
    }
    
    
    
    static __QueuePush = function(_asset)
    {
        //TODO
    }
    
    static __QueueBehaviorSet = function(_behavior)
    {
        //TODO
    }
    
    static __QueueBehaviorGet = function()
    {
        //TODO
    }
    
    
    
    static __Tick = function(_deltaTimeFactor)
    {
        if ((__gmInstance == undefined) || !__gmInstance.__IsPlaying())
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(self, " has stopped played, returning to pool");
            __VINYL_RETURN_SELF_TO_POOL
        }
        else
        {
            var _delta = clamp(__gainTarget - __gainInput, -_deltaTimeFactor*__gainRate, _deltaTimeFactor*__gainRate);
            if (_delta != 0)
            {
                __gainInput  += _delta;
                __gainOutput += _delta;
                __outputChanged = true;
                
                if (__shutdown && (_delta < 0) && ((__gainInput <= 0) || (__gainOutput <= 0)))
                {
                    __Stop();
                    return;
                }
            }
            
            var _delta = clamp(__pitchTarget - __pitchInput, -_deltaTimeFactor*__pitchRate, _deltaTimeFactor*__pitchRate);
            if (_delta != 0)
            {
                __pitchInput  += _delta;
                __pitchOutput += _delta;
                __outputChanged = true;
            }
            
            if (__outputChanged)
            {
                __outputChanged = false;
                __gmInstance.__GainSet(__gainOutput);
                __gmInstance.__PitchSet(__pitchOutput);
            }
        }
    }
}