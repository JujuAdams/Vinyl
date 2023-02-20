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
    }
    
    static __Play = function(_emitter, _assetArray, _loop, _gain, _pitch, _pan)
    {
        //TODO
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        //TODO
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