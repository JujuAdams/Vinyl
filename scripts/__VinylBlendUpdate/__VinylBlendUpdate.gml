function __VinylBlendUpdate() //FIXME - Broken using new decibel gains
{
    var _size = array_length(__sources);
    
    if (__blendAnimCurve == undefined)
    {
        var _t = __blendParam*(_size - 1);
        var _i = 0;
        repeat(_size)
        {
            __blendGains[@ _i] = lerp(VINYL_GAIN_SILENT, 0, max(0.0, 1.0 - abs(_t - _i)));
            ++_i;
        }
        
        exit;
    }
    
    var _i = 0;
    repeat(_size)
    {
        __blendGains[@ _i] = animcurve_channel_evaluate(animcurve_get_channel(__blendAnimCurve, _i), __blendParam);
        ++_i;
    }
}