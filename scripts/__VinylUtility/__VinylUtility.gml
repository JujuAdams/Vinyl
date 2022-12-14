function __VinylPitchToFreqCoeff(_pitch)
{
    return power(2, _pitch/12);
}

function __VinylFreqCoeffToPitch(_freqCoeff)
{
    return (_freqCoeff <= 0)? -infinity : (ln(_freqCoeff)*17.3123404906675608883190961); //12 * ln(2)
}

function __VinylGainToAmplitudeCoeff(_gain)
{
    return power(10, _gain/20);
}

function __VinylAmplitudeCoeffToGain(_amplitudeCoeff)
{
    return ((_amplitudeCoeff <= 0)? -infinity : 20*log10(_amplitudeCoeff));
}