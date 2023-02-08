function __VinylClassEmitterRef() constructor
{
    __emitter = __VinylDepoolEmitter();
    __emitter.__reference = weak_ref_create(self);
    
    static __GetEmitter = function()
    {
        return (__emitter == undefined)? undefined : __emitter.__emitter;
    }
    
    static __Falloff = function(_min, _max, _factor = 1)
    {
        if (__emitter != undefined) __emitter.__Falloff(_min, _max, _factor);
        return self;
    }
    
    static __Point = function(_x, _y)
    {
        if (__emitter != undefined) __emitter.__Point(_x, _y);
        return self;
    }
    
    static __Circle = function(_x, _y, _radius)
    {
        if (__emitter != undefined) __emitter.__Circle(_x, _y, _radius);
        return self;
    }
    
    static __Rectangle = function(_left, _top, _right, _bottom)
    {
        if (__emitter != undefined) __emitter.__Rectangle(_left, _top, _right, _bottom);
        return self;
    }
    
    static __Destroy = function()
    {
        __emitter.__Pool();
        __emitter = undefined;
    }
    
    static __DebugDraw = function()
    {
        if (__emitter != undefined) __emitter.__DebugDraw();
    }
    
    static toString = function()
    {
        return string(__emitter);
    }
}