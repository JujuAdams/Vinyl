function __VinylClassGroup(_name) constructor
{
    __name         = _name;
    __children     = [];
    __inheritArray = [];
    
    __gain       = 0.0;
    __gainRate   = infinity;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = infinity;
    __pitchTarget = undefined;
    
    __gainFinal  = 0.0;
    __pitchFinal = 1.0;
    
    
    
    #region Public Methods
    
    static GainSet = function(_target, _rate = infinity)
    {
        __gainTarget = _target;
        __gainRate   = _rate;
        
        if (__gainRate == infinity) __gain = _target;
        
        return self;
    }
    
    static GainGet = function()
    {
        return __gain;
    }
    
    static GainTargetGet = function()
    {
        return __gainTarget;
    }
    
    static GainAtTarget = function()
    {
        return (__gain == __gainTarget);
    }
    
    static PitchSet = function(_target, _rate = infinity)
    {
        __pitchTarget = _target;
        __pitchRate   = _rate;
        
        if (__pitchRate == infinity) __pitch = _target;
        
        return self;
    }
    
    static PitchGet = function()
    {
        return __pitch;
    }
    
    static PitchTargetGet = function()
    {
        return __pitchTarget;
    }
    
    static PitchAtTarget = function()
    {
        return (__pitch == __pitchTarget);
    }
    
    static GroupInherit = function()
    {
        if (argument_count <= 0) return self;
        
        //If we passed in multiple arguments, iterate over it and re-execute the function
        if (argument_count > 1)
        {
            var _i = 0;
            repeat(argument_count)
            {
                GroupInherit(argument[_i]);
                ++_i;
            }
            
            return self;
        }
        
        var _groupName = argument[0];
        
        //If we passed in an array, iterate over it and re-execute the function
        if (is_array(_groupName))
        {
            var _i = 0;
            repeat(array_length(_groupName))
            {
                GroupInherit(_groupName[_i]);
                ++_i;
            }
            
            return self;
        }
        
        var _group = VinylGroup(_groupName);
        if (_group == undefined) __VinylError("Group \"", _groupName, "\" doesn't exist");
        
        //Don't allow duplicate groups
        var _i = 0;
        repeat(array_length(__inheritArray))
        {
            if (__inheritArray[_i] == _groupName) return self;
            ++_i;
        }
        
        var _inheritanceStack = _group.__CheckInheritanceCycle(__name, __name)
        if (is_string(_inheritanceStack)) __VinylError("Group \"", __name, "\" inheriting \"", _groupName, "\" causes an inheritance cycle\n", _inheritanceStack);
        
        array_push(__inheritArray, _groupName);
        
        return self;
    }
    
    static __CheckInheritanceCycle = function(_groupName, _stack)
    {
        _stack += " -> " + __name;
        
        if (_groupName == __name) return _stack;
        
        var _i = 0;
        repeat(array_length(__inheritArray))
        {
            var _newStack = VinylGroup(__inheritArray[_i]).__CheckInheritanceCycle(_groupName, _stack);
            if (is_string(_newStack)) return _newStack;
            ++_i;
        }
        
        return undefined;
    }
    
    static GroupDisinherit = function(_groupOrArray)
    {
        //If we passed in an array, iterate over it and re-execute the function
        if (is_array(_groupOrArray))
        {
            var _i = 0;
            repeat(array_length(_groupOrArray))
            {
                GroupDisinherit(_groupOrArray[_i]);
                ++_i;
            }
            
            return self;
        }
        
        var _i = 0;
        repeat(array_length(__inheritArray))
        {
            if (__inheritArray[_i] == _groupOrArray)
            {
                array_delete(__inheritArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        return self;
    }
    
    static GroupClear = function()
    {
        __inheritArray = [];
        
        return self;
    }
    
    #endregion
    
    
    
    #region Private Methods
    
    static __Tick = function()
    {
        //If our gain or pitch targets are undefined then we should set them!
        if (__gainTarget  == undefined) __gainTarget  = __gain;
        if (__pitchTarget == undefined) __pitchTarget = __pitch;
        
        //Tween to the gain/pitch target
        if (__gain  != __gainTarget ) __gain  += clamp(__gainTarget  - __gain , -__gainRate , __gainRate );
        if (__pitch != __pitchTarget) __pitch += clamp(__pitchTarget - __pitch, -__pitchRate, __pitchRate);
        
        __gainFinal  = __gain + __VinylGroupsGainFinalGet(__inheritArray);
        __pitchFinal = __pitch*__VinylGroupsPitchFinalGet(__inheritArray);
    }
    
    static __ChildAdd = function(_instance)
    {
        var _found = false;
        var _i = 0;
        repeat(array_length(__children))
        {
            var _childRef = __children[_i];
            if (!weak_ref_alive(_childRef))
            {
                //If our group reference is invalid, delete this entry
                array_delete(__children, _i, 1);
            }
            else
            {
                if (_childRef.ref == _instance)
                {
                    _found = true;
                    break;
                }
                
                ++_i;
            }
        }
        
        if (_found)
        {
            if (VINYL_DEBUG) __VinylTrace(_instance, " is already a child of group \"", self, "\"");
        }
        else
        {
            if (VINYL_DEBUG) __VinylTrace(_instance, " added as a child of group \"", self, "\"");
            array_push(__children, weak_ref_create(_instance));
        }
    }
    
    static __ChildDelete = function(_instance)
    {
        var _i = 0;
        repeat(array_length(__children))
        {
            var _childRef = __children[_i];
            if (!weak_ref_alive(_childRef))
            {
                //If our group reference is invalid, delete this entry
                array_delete(__children, _i, 1);
            }
            else
            {
                if (_childRef.ref == _instance)
                {
                    if (VINYL_DEBUG) __VinylTrace(_instance, " deleted from children of group \"", self, "\"");
                    array_delete(__children, _i, 1);
                }
                else
                {
                    ++_i;
                }
            }
        }
    }
    
    static toString = function()
    {
        return __name;
    }
    
    #endregion
}

//Returns the resultant gain for the given set of groups
//TODO - Optimise using a cache I suppose?
function __VinylGroupsGainFinalGet(_groupArray)
{
    if (!is_array(_groupArray)) return 0;
    
    var _gain = 0;
    
    var _i = 0;
    repeat(array_length(_groupArray))
    {
        var _group = global.__vinylGroupsDict[$ _groupArray[_i]];
        if (is_struct(_group)) _gain += _group.__gainFinal;
        ++_i;
    }
    
    return _gain;
}

//Returns the resultant pitch for the given set of groups
//TODO - Optimise using a cache I suppose?
function __VinylGroupsPitchFinalGet(_groupArray)
{
    if (!is_array(_groupArray)) return 0;
    
    var _pitch = 1;
    
    var _i = 0;
    repeat(array_length(_groupArray))
    {
        var _group = global.__vinylGroupsDict[$ _groupArray[_i]];
        if (is_struct(_group)) _pitch *= _group.__pitchFinal;
        ++_i;
    }
    
    return _pitch;
}