/// @param name
/// @param knobDict
/// @param knobArray

function __VinylClassKnob(_name, _knobDict, _knobArray) constructor
{
    _knobDict[$ _name] = self;
    array_push(_knobArray, self);
    
    __name = _name;
        
    __default     = 0;
    __setValue    = undefined;
    __actualValue = undefined;
    
    __targetArray = [];
    
    
    
    static __TargetCreate = function(_scope, _property)
    {
        array_push(__targetArray, new __VinylClassKnobTarget(_scope, _property));
    }
    
    static __Initialize = function(_knobData = 0)
    {
        var _default = _knobData;
        
        __default     = _default;
        __setValue    = undefined;
        __actualValue = __default;
    }
    
    static __Set = function(_newSetValue)
    {
        var _newActualValue = _newSetValue ?? __default;
        if (_newActualValue != __actualValue)
        {
            __setValue    = _newSetValue;
            __actualValue = _newActualValue;
            
            __UpdateTargets();
        }
    }
    
    static __Refresh = function()
    {
        __actualValue = __setValue ?? __default;
        __UpdateTargets();
    }
    
    static __UpdateTargets = function()
    {
        var _actualValue = __actualValue;
        
        var _i = 0;
        repeat(array_length(__targetArray))
        {
            var _target = __targetArray[_i];
            _target.__Update(_actualValue);
            ++_i;
        }
    }
}