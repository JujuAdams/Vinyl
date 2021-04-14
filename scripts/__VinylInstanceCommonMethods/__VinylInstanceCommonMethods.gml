//Gain access
function __VinylInstanceGainSet(_value)
{
    __gain = _value;
        
    return self;
}

function __VinylInstanceGainTargetSet(_target, _rate)
{
    __gainTarget = _target;
    __gainRate   = _rate;
        
    return self;
}

function __VinylInstanceGainGet()
{
    return __gain;
}

//Pitch access
function __VinylInstancePitchSet(_value)
{
    __pitch = _value;
        
    return self;
}

function __VinylInstancePitchTargetSet(_target, _rate)
{
    __pitchTarget = _target;
    __pitchRate   = _rate;
        
    return self;
}

function __VinylInstancePitchGet()
{
    return __pitch;
}

//Fade time access
function __VinylInstanceFadeTimeSet(_inTime, _outTime)
{
    __timeFadeIn  = _inTime;
    __timeFadeOut = _outTime;
        
    return self;
}

function __VinylInstanceFadeTimeGet()
{
    return {
        in  : __timeFadeIn,
        out : __timeFadeOut
    };
}

function __VinylInstancePatternGet()
{
    return __pattern;
}

function __VinylInstanceIsStopping()
{
    return __stopping;
}

function __VinylInstanceIsFinished()
{
    return __finished;
}





function __VinylInstanceCommonConstruct(_pattern)
{
    __pattern = _pattern;
    __parent  = undefined;
    
    __gain       = 1.0;
    __gainRate   = VINYL_DEFAULT_GAIN_RATE;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    __pitchTarget = undefined;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
    
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
}

function __VinylInstanceCommonReset()
{
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
    
    __gain  = undefined;
    __pitch = undefined;
    
    if (__pattern != undefined)
    {
        if (__pattern.__timeFadeIn  != undefined) __timeFadeIn  = __pattern.__timeFadeIn;
        if (__pattern.__timeFadeOut != undefined) __timeFadeOut = __pattern.__timeFadeOut;
        
        //Randomise the gain/pitch as is appropriate
        __gain  = random_range(__pattern.__gainMin , __pattern.__gainMax );
        __pitch = random_range(__pattern.__pitchMin, __pattern.__pitchMax);
    }
}

function __VinylInstanceCommonPlay()
{
    if (VINYL_DEBUG) __VinylTrace("Playing ", self, " (gain=", __gain, ", pitch=", __pitch, ")");
    
    Kill();
    __Reset();
    
    //Set state
    __started = true;
    __timeStarted = current_time;
    
    __VinylInstanceCommonTick();
}

function __VinylInstanceCommonTick()
{
    var _finalGain  = 1.0;
    var _finalPitch = 1.0;
    
    //Find our parent's gain and pitch
    if (is_struct(__parent))
    {
        _finalGain  *= __parent.__gain;
        _finalPitch *= __parent.__pitch;
    }
    
    //Calculate and apply the fade gain
    if (!__finished)
    {
        if (__timeFadeIn > 0)
        {
            _finalGain *= clamp((current_time - __timeStarted) / __timeFadeIn, 0.0, 1.0);
        }
        
        if (__stopping && (__timeFadeOut > 0))
        {
            _finalGain *= 1.0 - clamp((current_time - __timeStopping) / __timeFadeOut, 0.0, 1.0);
        }
    }
    
    //If our gain or pitch targets are undefined then we should set them!
    if (__gainTarget  == undefined) __gainTarget  = __gain;
    if (__pitchTarget == undefined) __pitchTarget = __pitch;
    
    //Tween to the gain/pitch target
    if (__gain  != __gainTarget ) gain  += clamp(__gainTarget  - __gain , -__gainRate , __gainRate );
    if (__pitch != __pitchTarget) pitch += clamp(__pitchTarget - __pitch, -__pitchRate, __pitchRate);
    
    //Set our final gain
    __gain  *= _finalGain;
    __pitch *= _finalPitch;
}