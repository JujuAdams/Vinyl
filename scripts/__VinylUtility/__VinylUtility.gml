function __VinylPitchToFreq(_pitch)
{
    return power(2, _pitch/12);
}

function __VinylFreqToPitch(_freq)
{
    return (_freq <= 0)? -infinity : (ln(_freq)*17.3123404906675608883190961); //12 * ln(2)
}

function __VinylGainToAmplitudeCoeff(_gain)
{
    return power(10, _gain/20);
}

function __VinylAmplitudeCoeffToGain(_amplitudeCoeff)
{
    return ((_amplitudeCoeff <= 0)? -infinity : 20*log10(_amplitudeCoeff));
}