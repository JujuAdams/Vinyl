function __VinylClassBrainInterface() constructor
{
    static __ImplPlayOmni = function(_gain, _pitch)
    {
        __VinylDevError($"`VinylPlayOmni()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplPlayLoopOmni = function(_gain, _pitch)
    {
        __VinylDevError($"`VinylPlayLoopOmni()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplPlayAt = function(_x, _y, _z, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayAt()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplPlayLoopAt = function(_x, _y, _z, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayLoopAt()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplPlayOn = function(_emitter, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayOn()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplPlayLoopOn = function(_emitter, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayLoopOn()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplStop = function()
    {
        __VinylDevError($"`VinylStop()` not supported this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAnyPlaying = function()
    {
        __VinylDevError($"`VinylGetAnyPlaying()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAllPlaying = function()
    {
        __VinylDevError($"`VinylGetAllPlaying()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetVoice = function()
    {
        __VinylDevError($"Voice getter not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplSetGain = function(_gain, _time)
    {
        __VinylDevError($"`VinylSetGain()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetGain = function()
    {
        __VinylDevError($"`VinylGetGain()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplSetPitch = function(_pitch)
    {
        __VinylDevError($"`VinylSetPitch()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetPitch = function()
    {
        __VinylDevError($"`VinylGetPitch()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplSetLoop = function(_state)
    {
        __VinylDevError($"`VinylSetLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAnyLoop = function()
    {
        __VinylDevError($"`VinylGetAnyLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAllLoop = function()
    {
        __VinylDevError($"`VinylGetAllLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplPause = function()
    {
        __VinylDevError($"`VinylGetPause()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplResume = function()
    {
        __VinylDevError($"`VinylGetResume()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAllPaused = function()
    {
        __VinylDevError($"`VinylGetAllPaused()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __ImplGetAnyPaused = function()
    {
        __VinylDevError($"`VinylGetAnyPaused()` not supported for this struct type ({instanceof(self)})");
    }
}