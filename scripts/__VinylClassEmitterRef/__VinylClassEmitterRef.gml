function __VinylClassEmitterRef() constructor
{
    __emitter = __VinylDepoolEmitter();
    __emitter.__reference = weak_ref_create(self);
    
    static GetEmitter = function()
    {
        return (__emitter == undefined)? undefined : __emitter.__emitter;
    }
    
    static Falloff = function(_min, _max, _factor = 1)
    {
        if (__emitter != undefined) __emitter.Falloff(_min, _max, _factor);
        return self;
    }
    
    static Point = function(_x, _y)
    {
        if (__emitter != undefined) __emitter.Point(_x, _y);
        return self;
    }
    
    static Circle = function(_x, _y, _radius)
    {
        if (__emitter != undefined) __emitter.Circle(_x, _y, _radius);
        return self;
    }
    
    static Rectangle = function(_left, _top, _right, _bottom)
    {
        if (__emitter != undefined) __emitter.Rectangle(_left, _top, _right, _bottom);
        return self;
    }
    
    static Destroy = function()
    {
        __emitter.__Pool();
        __emitter = undefined;
    }
    
    static DebugDraw = function()
    {
        if (__emitter != undefined) __emitter.DebugDraw();
    }
    
    static toString = function()
    {
        return string(__emitter);
    }
}