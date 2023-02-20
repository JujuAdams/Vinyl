function __VinylClassInstanceMulti() : __VinylClassInstanceCommon() constructor
{
    __ResetState();
    
    static __patternType = "multi";
    
    static toString = function()
    {
        return "<multi inst " + string(__id) + ">";
    }
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __ResetStateCommon();
        
        __gmInstance = undefined;
    }
    
    static __Play = function(_emitter, _assetArray, _loop, _gain, _pitch, _pan)
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
    
    static __MultiChannelCountGet = function(_asset)
    {
        //TODO
    }
    
    static __MultiGainSet = function(_index, _gain)
    {
        //TODO
    }
    
    static __MultiGainGet = function(_index)
    {
        //TODO
    }
    
    static __MultiBlendSet = function(_blendFactor)
    {
        //TODO
    }
    
    static __MultiBlendGet = function()
    {
        //TODO
    }
    
    static __MultiSyncSet = function(_state)
    {
        //TODO
    }
    
    static __MultiSyncGet = function()
    {
        //TODO
    }
}