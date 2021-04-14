function __VinylClassGroup(_name) constructor
{
    __name     = _name;
    __children = [];
    
    __gain       = 1.0;
    __gainRate   = VINYL_DEFAULT_GAIN_RATE;
    __gainTarget = undefined;
    
    __pitch       = 1.0;
    __pitchRate   = VINYL_DEFAULT_PITCH_RATE;
    __pitchTarget = undefined;
    
    
    
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