#region Gain

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

#endregion



#region Pitch

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

#endregion



#region Fade Time

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

#endregion



#region Groups

function __VinylPatternGroupAdd(_name)
{
    if (!VinylGroupExists(_name))
    {
        __VinylError("Group \"", _name, "\" not defined");
    }
    
    if (!__VinylPatternGroupAssigned(_name))
    {
        if (VINYL_DEBUG) __VinylTrace(self, " added to group \"", _name, "\"");
        array_push(__groups, _name);
    }
    
    return self;
}

function __VinylPatternGroupDelete(_name)
{
    if (!VinylGroupExists(_name))
    {
        __VinylError("Group \"", _name, "\" not defined");
    }
    
    var _i = 0;
    repeat(array_length(__groups))
    {
        if (__groups[_i] == _name)
        {
            if (VINYL_DEBUG) __VinylTrace(self, " deleted from group \"", _name, "\"");
            array_delete(__groups, _i, 1);
        }
        else
        {
            ++_i;
        }
    }
    
    return self;
}

function __VinylPatternGroupAssigned(_name)
{
    if (!VinylGroupExists(_name))
    {
        __VinylError("Group \"", _name, "\" not defined");
    }
    
    var _i = 0;
    repeat(array_length(__groups))
    {
        if (__groups[_i] == _name) return true;
        ++_i;
    }
    
    return false;
}

function __VinylPatternGroupClear()
{
    if (VINYL_DEBUG) __VinylTrace("Clearing groups for ", self);
    
    __groups = [];
    
    return self;
}

#endregion



function __VinylPatternCommonConstruct(_instanceConstructor)
{
    __instanceConstructor = _instanceConstructor;
    
    __groups = [];
    
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
        ds_list_add(global.__vinylPlaying, self);
        
        __Reset();
        
        __VinylInstanceCommonApplyPatternGroups();
        
        return self;
    }
}

function __VinylPatternInstantiate(_pattern)
{
    with(_pattern)
    {
        return new __instanceConstructor(self);
    }
}