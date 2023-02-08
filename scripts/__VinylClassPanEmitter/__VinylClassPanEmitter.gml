function __VinylClassPanEmitter() constructor
{
    static __globalData           = __VinylGlobalData();
    static __panEmitterActive     = __globalData.__panEmitterActive;
    static __panEmitterPoolReturn = __globalData.__panEmitterPoolReturn;
    
    
    
    __id = undefined;
    __pooled = true;
    
    audio_falloff_set_model(audio_falloff_none);
    __emitter = audio_emitter_create();
    audio_emitter_falloff(__emitter, 1, 1, 1);
    audio_falloff_set_model(__VINYL_FALLOFF_MODEL);
    
    __ResetState();
    
    
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __pan = 0;
        
        __busName = "main";
        
        audio_emitter_bus(__emitter, audio_bus_main);
        
        __UpdatePosition();
    }
    
    
    
    static __UpdatePosition = function()
    {
        audio_emitter_position(__emitter, __globalData.__listenerX + __pan, __globalData.__listenerY, 0);
    }
    
    static __Pan = function(_pan)
    {
        _pan = clamp(_pan, -1, 1);
        
        if (_pan != __pan)
        {
            __pan = _pan;
            __UpdatePosition();
        }
    }
    
    static __Bus = function(_busName)
    {
        __busName = _busName;
        audio_emitter_bus(__emitter, __VinylGetEffectBus(__busName));
    }
    
    static __Depool = function(_id)
    {
        if (!__pooled) return;
        __pooled = false;
        
        __id = _id;
        
        array_push(__panEmitterActive, self);
        
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Depooling ", self);
    }
    
    static __Pool = function()
    {
        if (__pooled) return;
        __pooled = true;
        
        __ResetState();
        
        //Remove this pan emitter from the active array
        var _i = 0;
        repeat(array_length(__panEmitterActive))
        {
            if (__panEmitterActive[_i] == self)
            {
                array_delete(__panEmitterActive, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        //Move this instance to the "return" array
        //This prevents an instance being pooled and depooled in the same step
        //which would lead to problems with labels tracking what they're playing
        array_push(__panEmitterPoolReturn, self);
        
        __id = undefined;
    }
    
    static toString = function()
    {
        return "<pan emitter " + string(__id) + ">";
    }
}