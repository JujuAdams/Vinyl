function __VinylBlendUpdate()
{
    var _size = array_length(__sources);
    
    if (__blendParam == undefined)
    {
        __blendGains = array_create(_size, 0);
        return;
    }
    
    if (__blendAnimCurve == undefined)
    {
        var _t = __blendParam*(_size - 1);
        var _i = 0;
        repeat(_size)
        {
            __blendGains[@ _i] = VINYL_GAIN_SILENT*abs(_t - _i);
            ++_i;
        }
        
        return;
    }
    
    var _i = 0;
    repeat(_size)
    {
        __blendGains[@ _i] = animcurve_channel_evaluate(animcurve_get_channel(__blendAnimCurve, _i), __blendParam);
        ++_i;
    }
}