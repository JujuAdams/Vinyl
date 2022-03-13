#macro __VINYL_INSTANCE_COMMON  __VinylInstanceCommonConstruct(_pattern);\
                                static GainSet         = __VinylInstanceGainSet;\
                                static GainGet         = __VinylInstanceGainGet;\
                                static PitchSet        = __VinylInstancePitchSet;\
                                static PitchGet        = __VinylInstancePitchGet;\
                                static MusicalPitchSet = __VinylInstanceMusicalPitchSet;\
                                static MusicalPitchGet = __VinylInstanceMusicalPitchGet;\
                                static FadeTimeSet     = __VinylInstanceFadeTimeSet;\
                                static FadeTimeGet     = __VinylInstanceFadeTimeGet;\
                                static PatternGet      = __VinylInstancePatternGet;\
                                static IsStopping      = __VinylInstanceIsStopping;\
                                static IsFinished      = __VinylInstanceIsFinished;



#region Gain

function __VinylInstanceGainSet(_target, _rate = infinity)
{
    __gainTarget = _target;
    __gainRate   = _rate;
    
    if (_rate == infinity) __gain = __gainTarget;
    
    return self;
}

function __VinylInstanceGainGet()
{
    return __gain;
}

#endregion



#region Pitch

function __VinylInstancePitchSet(_target, _rate = infinity)
{
    __pitchTarget = _target;
    __pitchRate   = _rate;
    
    if (_rate == infinity) __pitch = __pitchTarget;
        
    return self;
}

function __VinylInstancePitchGet()
{
    return __pitch;
}

function __VinylInstanceMusicalPitchSet(_value)
{
    __pitch       = __VinylPitchToFreqCoeff(_value);
    __pitchTarget = __pitch;
    
    return self;
}

function __VinylInstanceMusicalPitchGet()
{
    return __VinylFreqCoeffToPitch(__pitch);
}

#endregion



#region Fade Time

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

#endregion



#region Groups

function __VinylInstanceGroupAdd()
{
    if (VinylIsSoundInstance(__parent)) //TODO - Optimise
    {
        __VinylError("Groups can only be modified for sound instances without parents");
    }
    
    var _j = 0;
    repeat(argument_count)
    {
        var _name = argument[_j];
        
        if (!VinylGroupExists(_name))
        {
            __VinylError("Group \"", _name, "\" not defined");
        }
        
        if (!__VinylInstanceGroupAssigned(_name))
        {
            if (VINYL_DEBUG) __VinylTrace(self, " added to group \"", _name, "\"");
        
            var _group = global.__vinylGroupsMap[? _name];
            array_push(__groups, weak_ref_create(_group));
            _group.__ChildAdd(self);
        }
        
        ++_j;
    }
    
    return self;
}

function __VinylInstanceGroupDelete()
{
    if (VinylIsSoundInstance(__parent)) //TODO - Optimise
    {
        __VinylError("Groups can only be modified for sound instances without parents");
    }
    
    var _j = 0;
    repeat(argument_count)
    {
        var _name = argument[_j];
        
        if (!VinylGroupExists(_name))
        {
            __VinylError("Group \"", _name, "\" not defined");
        }
        
        var _group = global.__vinylGroupsMap[? _name];
        _group.__ChildDelete(self);
        
        var _i = 0;
        repeat(array_length(__groups))
        {
            var _groupRef = __groups[_i];
            if (!weak_ref_alive(_groupRef))
            {
                //If our group reference is invalid, delete this entry
                array_delete(__groups, _i, 1);
            }
            else
            {
                if (_groupRef.ref == _group)
                {
                    if (VINYL_DEBUG) __VinylTrace(self, " deleted from group \"", _name, "\"");
                    array_delete(__groups, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
        }
        
        ++_j;
    }
    
    return self;
}

function __VinylInstanceGroupAssigned(_name)
{
    if (VinylIsSoundInstance(__parent)) //TODO - Optimise
    {
        __VinylError("Groups can only be modified for sound instances without parents");
    }
    
    if (!VinylGroupExists(_name))
    {
        __VinylError("Group \"", _name, "\" not defined");
    }
    
    var _group = global.__vinylGroupsMap[? _name];
    
    var _i = 0;
    repeat(array_length(__groups))
    {
        var _groupRef = __groups[_i];
        if (!weak_ref_alive(_groupRef))
        {
            //If our group reference is invalid, delete this entry
            array_delete(__groups, _i, 1);
        }
        else
        {
            if (_groupRef.ref == _group) return true;
            ++_i;
        }
    }
    
    return false;
}

function __VinylInstanceGroupClear()
{
    if (VinylIsSoundInstance(__parent)) //TODO - Optimise
    {
        __VinylError("Groups can only be modified for sound instances without parents");
    }
    
    if (VINYL_DEBUG) __VinylTrace("Clearing groups for ", self);
    
    var _i = 0;
    repeat(array_length(__groups))
    {
        var _groupRef = __groups[_i];
        if (weak_ref_alive(_groupRef)) _groupRef.ref.__ChildDelete(self);
        ++_i;
    }
    
    __groups = [];
    
    return self;
}

#endregion



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
    __pattern    = _pattern;
    __parent     = undefined;
    __groups     = [];
    
    __gain       = 0.0;
    __gainRate   = infinity;
    __gainTarget = undefined;
    __outputGain = 0.0;
    
    __inheritedBlendGain = 0.0;
    
    __pitch       = 1.0;
    __pitchRate   = infinity;
    __pitchTarget = undefined;
    __outputPitch = 1.0;
    
    __timeFadeIn  = undefined;
    __timeFadeOut = undefined;
    
    __started      = false;
    __timeStarted  = -1;
    __stopping     = false;
    __timeStopping = -1;
    __finished     = false;
}

function __VinylInstanceCommonApplyPatternGroups()
{
    var _array = __pattern.__groups;
    
    var _i = 0;
    repeat(array_length(_array))
    {
        var _group = VinylGroupGet(_array[_i]);
        
        _group.__ChildAdd(self);
        __groups[@ _i] = weak_ref_create(_group);
        
        ++_i;
    }
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
        __gain = random_range(__pattern.__gainMin, __pattern.__gainMax);
        
        if (__pattern.__pitchMusical)
        {
            __pitch = __VinylPitchToFreqCoeff(irandom_range(__pattern.__pitchMin, __pattern.__pitchMax));
        }
        else
        {
            __pitch = random_range(__pattern.__pitchMin, __pattern.__pitchMax);
        }
    }
}

function __VinylInstanceCommonPlay()
{
    if (VINYL_DEBUG) __VinylTrace("Playing ", self);
    
    Kill();
    __Reset();
    
    //Set state
    __started = true;
    __timeStarted = current_time;
    
    __VinylInstanceCommonTick();
    
    if (VINYL_DEBUG) __VinylTrace("(gain=", __outputGain, ", pitch=", __outputPitch, ", groups=", __VinylGroupArrayToString(__groups), ")");
}

function __VinylInstanceCommonTick()
{
    //If our gain or pitch targets are undefined then we should set them!
    if (__gainTarget  == undefined) __gainTarget  = __gain;
    if (__pitchTarget == undefined) __pitchTarget = __pitch;
    
    //Tween to the gain/pitch target
    if (__gain  != __gainTarget ) __gain  += clamp(__gainTarget  - __gain , -__gainRate , __gainRate );
    if (__pitch != __pitchTarget) __pitch += clamp(__pitchTarget - __pitch, -__pitchRate, __pitchRate);
    
    __outputGain  = __gain;
    __outputPitch = __pitch;
    
    //If we have a parent, multiply our output gain/pitch by their gain/pitch
    if (is_struct(__parent))
    {
        if (keyboard_check_pressed(ord("J"))) __VinylTrace(self, "    __parent = ", __parent, "    __outputGain = ", __parent.__outputGain);
        __outputGain  += __parent.__outputGain + __inheritedBlendGain;
        __outputPitch *= __parent.__outputPitch;
    }
    else
    {
        //Otherwise, since we have no parent, use our group to influence gain/pitch
        var _i = 0;
        repeat(array_length(__groups))
        {
            var _groupRef = __groups[_i];
            if (!weak_ref_alive(_groupRef))
            {
                //If our group reference is invalid, delete this entry
                array_delete(__groups, _i, 1);
            }
            else
            {
                var _group = _groupRef.ref;
                __outputGain  += _group.__gainFinal;
                __outputPitch *= _group.__pitchFinal;
                
                ++_i;
            }
        }
    }
    
    //Calculate and apply the fade gain
    if (!__finished)
    {
        if (__timeFadeIn > 0)
        {
            __outputGain += lerp(VINYL_GAIN_SILENT, 0, clamp((current_time - __timeStarted) / __timeFadeIn, 0.0, 1.0));
        }
        
        if (__stopping && (__timeFadeOut > 0))
        {
            __outputGain += lerp(VINYL_GAIN_SILENT, 0, 1.0 - clamp((current_time - __timeStopping) / __timeFadeOut, 0.0, 1.0));
        }
    }
}