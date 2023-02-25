/// @param name

function __VinylClassKnob(_name) constructor
{
    __name = _name;
        
    __default     = 0;
    __rangeLo     = 0;
    __rangeHi     = 1;
    __setValue    = undefined;
    __actualValue = undefined;
    
    __targetArray = [];
    
    
    
    static __Initialize = function(_knobData = 0)
    {
        if (is_numeric(_knobData))
        {
            __default = _knobData;
            __rangeLo = 0;
            __rangeHi = 1;
        }
        else if (is_struct(_knobData))
        {
            var _rangeArray = _knobData.range;
            if (is_undefined(_rangeArray))
            {
                __rangeLo = 0;
                __rangeHi = 1;
            }
            else if (is_array(_rangeArray))
            {
                 if (array_length(_rangeArray) != 2) __VinylError("Error in ", self, "\nRange array must have exactly two elements");
                 if (!is_numeric(_rangeArray[0])) __VinylError("Error in ", self, "\nRange array elements must be numbers (index 0 datatype=", typeof(_rangeArray[0]), ")");
                 if (!is_numeric(_rangeArray[1])) __VinylError("Error in ", self, "\nRange array elements must be numbers (index 1 datatype=", typeof(_rangeArray[1]), ")");
                 
                __rangeLo = _rangeArray[0];
                __rangeHi = _rangeArray[1];
            }
            else
            {
                __VinylError("Error in ", self, "\"\n\"range\" property must be a two-element array");
            }
            
            if (!variable_struct_exists(_knobData, "default")) __VinylError("Error in ", self, "\"\nKnob object must contain a \"default\" property");
            __default = clamp(_knobData[$ "default"], __rangeLo, __rangeHi);
        }
        else
        {
            __VinylError("Error in ", self, "\"\nKnob must be a number or an object");
        }
        
        __default = clamp(__default, __rangeLo, __rangeHi);
        __setValue    = undefined;
        __actualValue = __default;
    }
    
    static __Store = function()
    {
        var _knobDict  = __VinylGlobalData().__knobDict;
        var _knobArray = __VinylGlobalData().__knobArray;
        
        _knobDict[$ __name] = self;
        array_push(_knobArray, self);
    }
    
    static __RestoreOldValue = function(_oldKnobDict)
    {
        var _oldKnob = _oldKnobDict[$ __name];
        if (_oldKnob != undefined) __Set(_oldKnob.__Get());
    }
    
    static __TargetCreate = function(_scope, _property)
    {
        array_push(__targetArray, new __VinylClassKnobTarget(_scope, _property));
    }
    
    static __Set = function(_newSetValue)
    {
        if (_newSetValue == undefined)
        {
            _newSetValue = (__default - __rangeLo) / (__rangeHi - __rangeLo);
        }
        else
        {
            _newSetValue = clamp(_newSetValue, 0, 1);
        }
        
        var _newActualValue = lerp(__rangeLo, __rangeHi, _newSetValue);
        if (_newActualValue != __actualValue)
        {
            __setValue    = _newSetValue;
            __actualValue = _newActualValue;
            
            __UpdateTargets();
        }
    }
    
    static __Get = function()
    {
        return __setValue;
    }
    
    static __Refresh = function()
    {
        __actualValue = clamp(__setValue ?? __default, __rangeLo, __rangeHi);
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