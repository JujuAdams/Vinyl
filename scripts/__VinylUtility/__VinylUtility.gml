function __VinylSemitoneToPitch(_semitone)
{
    return power(2, _semitone/12);
}

function __VinylPitchToSemitone(_pitch)
{
    return (_pitch <= 0)? -infinity : (ln(_pitch)*0.173123404906675608883190961);
}

function __VinylGainToAmplitude(_gain)
{
    return power(10, _gain/20);
}

function __VinylAmplitudeToGain(_amplitudeCoeff)
{
    return ((_amplitudeCoeff <= 0)? -infinity : 20*log10(_amplitudeCoeff));
}

function __VinylCurveAmplitude(_value)
{
    if (__VINYL_USE_GAIN_CURVE)
    {
        return (power(20, _value/VINYL_MAX_GAIN)-1)/19;
    }
    else
    {
        return _value/VINYL_MAX_GAIN;
    }
}