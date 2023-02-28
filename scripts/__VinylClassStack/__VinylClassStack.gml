/// @param name

function __VinylClassStack(_name) constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __name = _name;
    
    __duckedGain  = 0;
    __duckRate    = VINYL_DEFAULT_DUCK_GAIN_RATE;
    __duckPause   = true;
    
    __maxPriority   = -infinity;
    __instanceArray = [];
    __priorityArray = [];
    
    
    
    static toString = function()
    {
        return "<stack " + string(__name) + ">";
    }
    
    static __Update = function(_stackData = {})
    {
        if (!is_struct(_stackData)) __VinylError("Error in ", self, "\nStack data must be a struct");
        if (VINYL_CONFIG_VALIDATE_PROPERTIES) __VinylValidateStruct(_stackData, ["ducked gain", "rate", "pause"]);
        
        __duckedGain = _stackData[$ "ducked gain"] ?? 0;
        __duckRate   = _stackData[$ "rate"       ] ?? VINYL_DEFAULT_DUCK_GAIN_RATE;
        __duckPause  = _stackData[$ "pause"      ] ?? true;
        
        if (!is_numeric(__duckedGain) || (__duckedGain < 0) || (__duckedGain > 1)) __VinylError("Error in ", self, "\n\"ducked gain\" must be a number between 0 and 1 (inclusive)");
        if (!is_numeric(__duckRate) || (__duckRate <= 0)) __VinylError("Error in ", self, "\n\"rate\" must be a number greater than 0");
        if (!is_bool(__duckPause)) __VinylError("Error in ", self, "\n\"pause\" must be either <true> or <false>");
        if (__duckPause && (__duckedGain > 0)) __VinylError("Error in ", self, "\n\"pause\" cannot be <true> is \"ducked gain\" is greater than 0");
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            __instanceArray[_i].__GainDuckSet(1, __duckRate);
            ++_i;
        }
    }
    
    static __MaxPriorityGet = function()
    {
        return __maxPriority;
    }
    
    static __Push = function(_priority, _instance, _onInstantiate)
    {
        if (_priority < __maxPriority)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _instance, " to stack \"", __name, "\" with lower priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            //We should duck down straight away since we're at a lower priority
            _instance.__GainDuckSet(__duckedGain, _onInstantiate? infinity : __duckRate, __duckPause, false);
            
            //Try to find an existing instance to replace
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                if (__priorityArray[_i] == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__instanceArray[_i], " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing instance with the same priority - fade out the existing instance and replace with ourselves
                    __instanceArray[_i].__GainDuckSet(0, __duckRate, __duckPause, false);
                    __instanceArray[@ _i] = _instance;
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _instance, " to stack \"", __name, "\"");
            
            //If no instance exists to replace, add the incoming instance
            array_push(__instanceArray, _instance);
            array_push(__priorityArray, _priority);
        }
        else //priority >= maxPriority
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _instance, " to stack \"", __name, "\" with sufficient priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            __maxPriority = _priority;
            
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                var _existingPriority = __priorityArray[_i];
                if (_existingPriority < _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__instanceArray[_i], " on stack \"", __name, "\" has lesser priorty (", _existingPriority, ") than incoming (", _priority, ")");
                    
                    //We found an existing instance with a lower priority - duck the existing instance
                    __instanceArray[_i].__GainDuckSet(__duckedGain, __duckRate, __duckPause, false);
                }
                else if (_existingPriority == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__instanceArray[_i], " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing instance with the same priority - fade out the existing instance and replace with ourselves
                    __instanceArray[_i].__GainDuckSet(0, __duckRate, false, true);
                    __instanceArray[@ _i] = _instance;
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _instance, " to stack \"", __name, "\"");
            
            //If no instance exists to replace, add the incoming instance
            array_push(__instanceArray, _instance);
            array_push(__priorityArray, _priority);
        }
    }
    
    static __Get = function(_priority)
    {
        var _i = 0;
        repeat(array_length(__priorityArray))
        {
            if (__priorityArray[_i] == _priority) return __instanceArray[_i];
            ++_i;
        }
    }
    
    static __Tick = function()
    {
        static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
        
        var _refresh = false;
        
        //Remove any stopped instances
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            if (!__instanceArray[_i].__IsPlaying())
            {
                if (__priorityArray[_i] >= __maxPriority) _refresh = true;
                array_delete(__instanceArray, _i, 1);
                array_delete(__priorityArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        if (_refresh)
        {
            //Find the instance with the highest priority
            __maxPriority = -infinity;
            var _maxInstance = undefined;
            
            var _i = 0;
            repeat(array_length(__instanceArray))
            {
                var _priority = __priorityArray[_i];
                if (_priority > __maxPriority)
                {
                    __maxPriority = _priority;
                    _maxInstance = __instanceArray[_i];
                }
                
                ++_i;
            }
            
            //Activate whatever instance is now the highest priority
            if (_maxInstance != undefined)
            {
                _maxInstance.__Resume();
                _maxInstance.__GainDuckSet(1, __duckRate, false, false);
            }
        }
    }
}