function __VinylBlendUpdate()
{
    if (__blendParam == undefined)
    {
        __blendGains = undefined;
        exit;
    }
    
    if (__blendAnimCurve == undefined)
    {
        var _size = array_length(__sources);
        __blendGains = array_create(_size, 1.0);
        
        var _t = __blendParam*(_size - 1);
        var _i = 0;
        repeat(_size)
        {
            __blendGains[@ _i] = max(0.0, 1.0 - abs(_t - _i));
            ++_i;
        }
        
        exit;
    }
    
    var _size = array_length(__sources);
    __blendGains = array_create(_size, 1.0);
    
    var _i = 0;
    repeat(_size)
    {
        __blendGains[@ _i] = animcurve_channel_evaluate(animcurve_get_channel(__blendAnimCurve, _i), __blendParam);
        ++_i;
    }
}