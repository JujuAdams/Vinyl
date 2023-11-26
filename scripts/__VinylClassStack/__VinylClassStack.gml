// Feather disable all

function __VinylClassStack() constructor
{
    static __globalData = __VinylGlobalData();
    
    
    
    __name = undefined;
    
    __maxPriority   = -infinity;
    __voiceArray    = [];
    __priorityArray = [];
    
    
    
    __Reset();
    
    static __Reset = function()
    {
        __name = undefined;
        
        __duckedGain      = 0;
        __duckRate        = VINYL_DEFAULT_DUCK_GAIN_RATE;
        __pauseWhenDucked = true;
    }
    
    static __Serialize = function(_struct)
    {
        //TODO - Compress on save
        
        _struct.name = __name;
        
        _struct.duckedGain      = __duckedGain;
        _struct.duckRate        = __duckRate;
        _struct.pauseWhenDucked = __pauseWhenDucked;
    }
    
    static __Deserialize = function(_struct, _parent)
    {
        //TODO - Decompress on load
        
        __name = _struct.name;
        
        __duckedGain      = _struct.duckedGain;
        __duckRate        = _struct.duckRate;
        __pauseWhenDucked = _struct.pauseWhenDucked;
    }
    
    static __Store = function(_document)
    {
        _document.__stackDict[$ __name] = self;
    }
    
    static __Discard = function(_document)
    {
        variable_struct_remove(_document.__stackDict, __name);
        __document.__Save();
    }
    
    
    
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
        __pauseWhenDucked  = _stackData[$ "pause"      ] ?? true;
        
        if (!is_numeric(__duckedGain) || (__duckedGain < 0) || (__duckedGain > 1)) __VinylError("Error in ", self, "\n\"ducked gain\" must be a number between 0 and 1 (inclusive)");
        if (!is_numeric(__duckRate) || (__duckRate <= 0)) __VinylError("Error in ", self, "\n\"rate\" must be a number greater than 0");
        if (!is_bool(__pauseWhenDucked)) __VinylError("Error in ", self, "\n\"pause\" must be either <true> or <false>");
        if (__pauseWhenDucked && (__duckedGain > 0)) __VinylError("Error in ", self, "\n\"pause\" cannot be <true> is \"ducked gain\" is greater than 0");
        
        __maxPriority = -infinity;
        array_resize(__voiceArray, 0);
        array_resize(__priorityArray, 0);
    }
    
    static __Destroy = function()
    {
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            __voiceArray[_i].__GainDuckSet(1, __duckRate);
            ++_i;
        }
    }
    
    static __MaxPriorityGet = function()
    {
        return __maxPriority;
    }
    
    static __Push = function(_priority, _voice, _onInstantiate)
    {
        if (_priority < __maxPriority)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _voice, " to stack \"", __name, "\" with lower priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            //We should duck down straight away since we're at a lower priority
            _voice.__GainDuckSet(__duckedGain, _onInstantiate? infinity : __duckRate, __pauseWhenDucked, false);
            
            //Try to find an existing voice to replace
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                if (__priorityArray[_i] == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__voiceArray[_i], " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                    __voiceArray[_i].__GainDuckSet(0, __duckRate, __pauseWhenDucked, false);
                    __voiceArray[@ _i] = _voice;
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _voice, " to stack \"", __name, "\"");
            
            //If no voice exists to replace, add the incoming voice
            array_push(__voiceArray, _voice);
            array_push(__priorityArray, _priority);
        }
        else //priority >= maxPriority
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _voice, " to stack \"", __name, "\" with sufficient priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            __maxPriority = _priority;
            
            var _i = 0;
            repeat(array_length(__priorityArray))
            {
                var _existingPriority = __priorityArray[_i];
                if (_existingPriority < _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__voiceArray[_i], " on stack \"", __name, "\" has lesser priorty (", _existingPriority, ") than incoming (", _priority, ")");
                    
                    //We found an existing voice with a lower priority - duck the existing voice
                    __voiceArray[_i].__GainDuckSet(__duckedGain, __duckRate, __pauseWhenDucked, false);
                }
                else if (_existingPriority == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(__voiceArray[_i], " on stack \"", __name, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                    __voiceArray[_i].__GainDuckSet(0, __duckRate, false, true);
                    __voiceArray[@ _i] = _voice;
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _voice, " to stack \"", __name, "\"");
            
            //If no voice exists to replace, add the incoming voice
            array_push(__voiceArray, _voice);
            array_push(__priorityArray, _priority);
        }
    }
    
    static __Get = function(_priority)
    {
        var _i = 0;
        repeat(array_length(__priorityArray))
        {
            if (__priorityArray[_i] == _priority) return __voiceArray[_i].__id;
            ++_i;
        }
    }
    
    static __Tick = function()
    {
        static _idToVoiceDict = __VinylGlobalData().__idToVoiceDict;
        
        var _refresh = false;
        
        //Remove any stopped voices
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            if (!__voiceArray[_i].__IsPlaying())
            {
                if (__priorityArray[_i] >= __maxPriority) _refresh = true;
                array_delete(__voiceArray, _i, 1);
                array_delete(__priorityArray, _i, 1);
            }
            else
            {
                ++_i;
            }
        }
        
        if (_refresh)
        {
            //Find the voice with the highest priority
            __maxPriority = -infinity;
            var _maxVoice = undefined;
            
            var _i = 0;
            repeat(array_length(__voiceArray))
            {
                var _priority = __priorityArray[_i];
                if (_priority > __maxPriority)
                {
                    __maxPriority = _priority;
                    _maxVoice = __voiceArray[_i];
                }
                
                ++_i;
            }
            
            //Activate whatever voice is now the highest priority
            if (_maxVoice != undefined)
            {
                _maxVoice.__ResumeDuck();
                _maxVoice.__GainDuckSet(1, __duckRate, false, false);
            }
        }
    }
}
