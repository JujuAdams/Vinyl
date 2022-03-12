function __VinylClassGroup(_name) constructor
{
    __name         = _name;
    __children     = [];
    __inheritArray = [];
    
    __gain       = 0.0;
    __gainRate   = VINYL_DEFAULT_GAIN_RATE;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    __pitchTarget = undefined;
    
    __gainFinal = 0.0;
    
    
    
    #region Public Methods
    
    static GainSet = function(_value)
    {
        __gain = _value;
        
        return self;
    }
    
    static GainTargetSet = function(_target, _rate)
    {
        __gainTarget = _target;
        __gainRate   = _rate;
        
        return self;
    }
    
    static GainGet = function()
    {
        return __gain;
    }
    
    static GainAtTarget = function()
    {
        return (__gain == __gainTarget);
    }
    
    static PitchSet = function(_value)
    {
        __pitch = _value;
        
        return self;
    }
    
    static PitchTargetSet = function(_target, _rate)
    {
        __pitchTarget = _target;
        __pitchRate   = _rate;
        
        return self;
    }
    
    static PitchGet = function()
    {
        return __pitch;
    }
    
    static PitchAtTarget = function()
    {
        return (__pitch == __pitchTarget);
    }
    
    static GroupInherit = function(_groupOrArray)
    {
        //If we passed in an array, iterate over it and re-execute the function
        if (is_array(_groupOrArray))
        {
            var _i = 0;
            repeat(array_length(_groupOrArray))
            {
                GroupInherit(_groupOrArray[_i]);
                ++_i;
            }
            
            return self;
        }
        
        var _i = 0;
        repeat(array_length(__inheritArray))
        {
            if (__inheritArray[_i] == _groupOrArray) return self;
            ++_i;
        }
        
        array_push(__inheritArray, _groupOrArray);
        
        return self;
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
        if (__gain  != __gainTarget ) gain  += clamp(__gainTarget  - __gain , -__gainRate , __gainRate );
        if (__pitch != __pitchTarget) pitch += clamp(__pitchTarget - __pitch, -__pitchRate, __pitchRate);
        
        __gainFinal = __gain + __VinylGroupsGainFinalGet(__inheritArray);
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
        var _group = global.__vinylGroupsMap[? _groupArray[_i]];
        if (is_struct(_group)) _gain += _group.__gainFinal;
        ++_i;
    }
    
    return _gain;
}