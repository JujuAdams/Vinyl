function __VinylPatternCommonConstruct(_instanceConstructor)
{
    __instanceConstructor = _instanceConstructor;
    
    __gainMin = 1.0;
    __gainMax = 1.0;
    
    __pitchMin = 1.0;
    __pitchMax = 1.0;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
}

function __VinylPatternPlay()
{
    with(__VinylPatternInstantiate(self))
    {
        __Reset();
        ds_list_add(global.__vinylPlaying, self);
        return self;
    }
}

//Gain access
function __VinylPatternGainSet()
{
    var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
    var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
    
    __gainMin = _min;
    __gainMax = _max;
    
    return self;
}

function __VinylPatternGainGet()
{
    return {
        mini : __gainMin,
        maxi : __gainMax
    };
}

//Pitch access
function __VinylPatternPitchSet()
{
    var _min = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : 1.0;
    var _max = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : _min;
    
    __pitchMin = _min;
    __pitchMax = _max;
    
    return self;
}

function __VinylPatternPitchGet()
{
    return {
        mini : __pitchMin,
        maxi : __pitchMax
    };
}

//Fade time access
function __VinylPatternFadeTimeSet(_inTime, _outTime)
{
    __timeFadeIn  = _inTime;
    __timeFadeOut = _outTime;
    
    return self;
}

function __VinylPatternFadeTimeGet()
{
    return {
        in  : __timeFadeIn,
        out : __timeFadeOut
    };
}

function __VinylPatternInstantiate(_pattern)
{
    with(_pattern)
    {
        return new __instanceConstructor(self);
    }
}