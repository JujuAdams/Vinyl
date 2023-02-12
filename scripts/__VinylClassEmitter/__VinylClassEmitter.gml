function __VinylClassEmitter() constructor
{
    static __globalData = __VinylGlobalData();
    static __pool       = __globalData.__poolEmitter;
    
    
    
    __id = undefined;
    __pooled = true;
    
    __emitter = audio_emitter_create();
    
    __ResetState();
    
    
    
    static __ResetState = function()
    {
        if ((VINYL_DEBUG_LEVEL >= 2) && (__id != undefined)) __VinylTrace("Resetting state for ", self);
        
        __reference = undefined;
        
        __mode = 0; //0 = __Point, 1 = __Circle, 2 = __Rectangle
        
        __actualX = 0;
        __actualY = 0;
        
        __x      = 0;
        __y      = 0;
        __radius = 0;
        
        __left   = 0;
        __top    = 0;
        __right  = 0;
        __bottom = 0;
        
        __falloffMin    = VINYL_DEFAULT_FALLOFF_MIN;
        __falloffMax    = VINYL_DEFAULT_FALLOFF_MAX;
        __falloffFactor = VINYL_DEFAULT_FALLOFF_FACTOR;
        
        __instanceIDArray = [];
        
        audio_emitter_position(__emitter, __actualX, __actualY, 0);
        audio_emitter_velocity(__emitter, 0, 0, 0);
        audio_emitter_gain(__emitter, 1);
        audio_emitter_falloff(__emitter, __falloffMin, __falloffMax, __falloffFactor);
        audio_emitter_bus(__emitter, audio_bus_main);
    }
    
    
    
    #region Public
    
    static __Falloff = function(_min, _max, _factor = 1)
    {
        _min = max(0, _min);
        _max = max(_min + math_get_epsilon(), _max);
        
        __falloffMin    = _min;
        __falloffMax    = _max;
        __falloffFactor = _factor;
        
        audio_emitter_falloff(__emitter, __falloffMin, __falloffMax, __falloffFactor);
    }
    
    static __Point = function(_x, _y)
    {
        __mode = 0;
        
        __x      = _x;
        __y      = _y;
        __radius = 0;
        
        __left   = _x;
        __top    = _y;
        __right  = _x;
        __bottom = _y;
        
        __ManagePosition();
    }
    
    static __Circle = function(_x, _y, _radius)
    {
        __mode = 1;
        
        __x      = _x;
        __y      = _y;
        __radius = _radius;
        
        __left   = _x;
        __top    = _y;
        __right  = _x;
        __bottom = _y;
        
        __ManagePosition();
    }
    
    static __Rectangle = function(_left, _top, _right, _bottom)
    {
        __mode = 2;
        
        __left   = _left;
        __top    = _top;
        __right  = _right;
        __bottom = _bottom;
        
        __x      = 0.5*(__left + __right);
        __y      = 0.5*(__top + __bottom);
        __radius = 0;
        
        __ManagePosition();
    }
    
    static __DebugDraw = function()
    {
        draw_line(__x-7, __y-7, __x+7, __y+7);
        draw_line(__x+7, __y-7, __x-7, __y+7);
        draw_rectangle(__actualX-3, __actualY-3, __actualX+3, __actualY+3, true);
        
        if (__mode == 1)
        {
            draw_circle(__x, __y, __radius, true);
        }
        else if (__mode == 2)
        {
            draw_rectangle(__left, __top, __right, __bottom, true);
        }
        
        draw_circle(__actualX, __actualY, __falloffMin, true);
        draw_circle(__actualX, __actualY, __falloffMax, true);
    }
    
    #endregion
    
    
    
    #region Private
    
    static __ManagePosition = function()
    {
        static __globalData = __VinylGlobalData();
        
        if (__mode == 0)
        {
            __actualX = __x;
            __actualY = __y;
        }
        else if (__mode == 1)
        {
            var _dX = __globalData.__listenerX - __x;
            var _dY = __globalData.__listenerY - __y;
            
            var _length = sqrt(_dX*_dX + _dY*_dY);
            if (_length > __radius)
            {
                var _factor = __radius/_length;
                __actualX = _factor*_dX + __x;
                __actualY = _factor*_dY + __y;
            }
            else
            {
                __actualX = __globalData.__listenerX;
                __actualY = __globalData.__listenerY;
            }
        }
        else if (__mode == 2)
        {
            __actualX = clamp(__globalData.__listenerX, __left, __right );
            __actualY = clamp(__globalData.__listenerY, __top,  __bottom);
        }
        
        audio_emitter_position(__emitter, __actualX, __actualY, 0);
    }
    
    static __Depool = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Depooling ", self);
    }
    
    static __Pool = function()
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pooling ", self);
        
        //Stop all instances playing on this emitter
        var _i = 0;
        repeat(array_length(__instanceIDArray))
        {
            VinylStop(__instanceIDArray[_i]);
            ++_i;
        }
        
        __ResetState();
        
        __pool.__Return(self);
    }
    
    static __Tick = function()
    {
        if (__reference == undefined)
        {
            __Pool();
        }
        else if (!weak_ref_alive(__reference))
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Lost reference for ", self);
            __Pool();
        }
        else
        {
            __ManagePosition();
        }
    }
    
    static toString = function()
    {
        return "<emitter " + string(__id) + ">";
    }
    
    #endregion
}