/// @param [update=false]

function VinylBrainCommonConstructor(_update = false) constructor
{
    static ImplUpdate = function()
    {
        __VinylDevError($"No update function has been defined for this struct type ({instanceof(self)})");
    }
    
    static ImplPlayOmni = function(_loop, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayOmni()` not supported this struct type ({instanceof(self)})");
    }
    
    static ImplPlayAt = function(_x, _y, _z, _loop, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayAt()` not supported this struct type ({instanceof(self)})");
    }
    
    static ImplPlayOn = function(_emitter, _loop, _gain, _pitch)
    {
        __VinylDevError($"`VinylPlayOn()` not supported this struct type ({instanceof(self)})");
    }
    
    static ImplStop = function()
    {
        __VinylDevError($"`VinylStop()` not supported this struct type ({instanceof(self)})");
    }
    
    static ImplGetAnyPlaying = function()
    {
        __VinylDevError($"`VinylGetAnyPlaying()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetAllPlaying = function()
    {
        __VinylDevError($"`VinylGetAllPlaying()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetWillStop = function()
    {
        __VinylDevError($"`VinylGetWillStop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetFlatVoiceArray = function()
    {
        __VinylDevError($"`VinylGetFlatVoiceArray()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetTrackPosition = function()
    {
        __VinylDevError($"`VinylGetTrackPosition()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplSetGain = function(_gain, _time)
    {
        __VinylDevError($"`VinylSetGain()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetGain = function()
    {
        __VinylDevError($"`VinylGetGain()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplSetPitch = function(_pitch)
    {
        __VinylDevError($"`VinylSetPitch()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetPitch = function()
    {
        __VinylDevError($"`VinylGetPitch()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplSetLoop = function(_state)
    {
        __VinylDevError($"`VinylSetLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetAnyLoop = function()
    {
        __VinylDevError($"`VinylGetAnyLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetAllLoop = function()
    {
        __VinylDevError($"`VinylGetAllLoop()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplPause = function()
    {
        __VinylDevError($"`VinylGetPause()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplResume = function()
    {
        __VinylDevError($"`VinylGetResume()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetAllPaused = function()
    {
        __VinylDevError($"`VinylGetAllPaused()` not supported for this struct type ({instanceof(self)})");
    }
    
    static ImplGetAnyPaused = function()
    {
        __VinylDevError($"`VinylGetAnyPaused()` not supported for this struct type ({instanceof(self)})");
    }
    
    static __brainInterface = true;
    
    if (_update)
    {
        array_push(__VinylSystem().__weakUpdateArray, weak_ref_create(self));
    }
}