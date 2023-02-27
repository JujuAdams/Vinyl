/// @param name

function __VinylClassStack(_name) constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __name = _name;
    
    __maxPriority   = -infinity;
    __instanceArray = [];
    __priorityArray = [];
    
    
    
    static toString = function()
    {
        return "<stack " + string(__name) + ">";
    }
    
    static __MaxPriorityGet = function()
    {
        return __maxPriority;
    }
    
    static __Push = function(_priority, _id)
    {
        if (_priority < __maxPriority)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", __VinylInstanceGet(_id), " to stack \"", __name, "\" with lower priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            //We should duck down straight away since we're at a lower priority
            VinylGainSet(_id, 0); //TODO - Replace with a specific stack gain value or pause
            
            //Try to find an existing instance to replace
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                if (__priorityArray[_i] == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__VinylInstanceGet(__instanceArray[_i]), " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing instance with the same priority - stop the existing instance and replace with ourselves
                    VinylStop(__instanceArray[_i]);
                    __instanceArray[@ _i] = _id;
                    
                    //TOGO - Trigger pause (if necessary)
                    
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", __VinylInstanceGet(_id), " to stack \"", __name, "\"");
            
            //If no instance exists to replace, add the incoming instance
            array_push(__instanceArray, _id);
            array_push(__priorityArray, _priority);
        }
        else //priority >= maxPriority
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", __VinylInstanceGet(_id), " to stack \"", __name, "\" with sufficient priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            __maxPriority = _priority;
            
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                var _existingPriority = __priorityArray[_i];
                if (_existingPriority < _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__VinylInstanceGet(__instanceArray[_i]), " on stack \"", __name, "\" has lesser priorty (", _existingPriority, ") than incoming (", _priority, ")");
                    
                    //We found an existing instance with a lower priority - duck the existing instance
                    VinylGainSet(__instanceArray[_i], 0); //TODO - Replace with a specific stack gain value or pause
                }
                else if (_existingPriority == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__VinylInstanceGet(__instanceArray[_i]), " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing instance with the same priority - fade out the existing instance and replace with ourselves
                    VinylStop(__instanceArray[_i]); //TODO - Replace with fade out
                    __instanceArray[@ _i] = _id;
                    
                    //TOGO - Trigger fade in (if necessary)
                    
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", __VinylInstanceGet(_id), " to stack \"", __name, "\"");
            
            //If no instance exists to replace, add the incoming instance
            array_push(__instanceArray, _id);
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
        var _refresh = false;
        
        var _i = 0;
        repeat(array_length(__instanceArray))
        {
            if (!VinylExists(__instanceArray[_i]))
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
            
            //Activate whatever instance we 
            if (_maxInstance != undefined)
            {
                VinylGainSet(_maxInstance, 1); //TODO - Replace with a specific stack gain value or pause
            }
        }
    }
    
    static __Update = function()
    {
        //TODO
    }
    
    static __Destroy = function()
    {
        //TODO
    }
}