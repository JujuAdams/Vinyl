// Feather disable all

/// @param duckName
/// @param duckedGain
/// @param rateOfChange
/// @param pauseOnDuck

function __VinylClassDuck(_duckName, _duckedGain, _rateOfChange, _pauseOnDuck) constructor
{
    static _toUpdateArray = __VinylSystem().__toUpdateArray;
    
    __duckName     = _duckName;
    __duckedGain   = _duckedGain;
    __rateOfChange = _rateOfChange;
    __pauseOnDuck  = _pauseOnDuck;
    
    __maxPriority   = -infinity;
    __voiceArray    = [];
    __priorityArray = [];
    
    
    
    
    
    static __UpdateSetup = function(_duckedGain, _rateOfChange, _pauseOnDuck)
    {
        if (VINYL_LIVE_EDIT)
        {
            array_push(_toUpdateArray, self);
        }
        
        __duckedGain   = _duckedGain;
        __rateOfChange = _rateOfChange;
        __pauseOnDuck  = _pauseOnDuck;
    }
    
    static __ClearSetup = function()
    {
        __UpdateSetup(0, __VINYL_DEFAULT_DUCK_RATE_OF_GAIN, true);
    }
    
    static __Push = function(_voiceStruct, _priority, _doDuck)
    {
        var _priorityArray = __priorityArray;
        var _voiceArray    = __voiceArray;
        
        if (_priority < __maxPriority)
        {
            if (_doDuck) _voiceStruct.__Duck(__duckedGain, __rateOfChange, __behaviour);
            
            //Try to find an existing voice to replace
            var _index = array_get_index(_priorityArray, _priority);
            if (_index >= 0)
            {
                //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                _voiceArray[_i].__FadeOut(__rateOfChange);
                _voiceArray[_i] = _voiceStruct;
            }
            else
            {
                //If no voice exists to replace, add the incoming voice
                array_push(_voiceArray, _voiceStruct);
                array_push(_priorityArray, _priority);
            }
        }
        else //priority >= maxPriority
        {
            __maxPriority = _priority;
            
            if (_doDuck) _voiceStruct.__Duck(1, __rateOfChange, __VINYL_DUCK.__DO_NOTHING);
            
            var _i = 0;
            repeat(array_length(_priorityArray))
            {
                var _existingPriority = _priorityArray[_i];
                if (_existingPriority < _priority)
                {
                    //We found an existing voice with a lower priority - duck the existing voice
                    _voiceArray[_i].__Duck(__duckedGain, __rateOfChange, __pauseOnDuck? __VINYL_DUCK.__PAUSE : __VINYL_DUCK.__DO_NOTHING);
                }
                else if (_existingPriority == _priority)
                {
                    //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                    _voiceArray[_i].__FadeOut(__rateOfChange);
                    _voiceArray[_i] = _voiceStruct;
                    return;
                }
                
                ++_i;
            }
            
            //If no voice exists to replace, add the incoming voice
            array_push(__voiceArray, _voiceStruct);
            array_push(__priorityArray, _priority);
        }
    }
    
    static __Get = function(_priority)
    {
        var _index = array_get_index(__priorityArray, _priority);
        return (_index < 0)? undefined : __voiceArray[_index]; //TODO - Return a voice index instead of the struct
    }
    
    static __Update = function()
    {
        var _priorityArray = __priorityArray;
        var _voiceArray    = __voiceArray;
        
        var _refresh = false;
        
        //Remove any stopped voices
        var _i = 0;
        repeat(array_length(_voiceArray))
        {
            if (!_voiceArray[_i].__IsPlaying())
            {
                if (_priorityArray[_i] >= __maxPriority) _refresh = true;
                array_delete(_voiceArray,    _i, 1);
                array_delete(_priorityArray, _i, 1);
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
                var _priority = _priorityArray[_i];
                if (_priority > __maxPriority)
                {
                    __maxPriority = _priority;
                    _maxVoice = _voiceArray[_i];
                }
                
                ++_i;
            }
            
            //Activate whatever voice is now the highest priority
            if (_maxVoice != undefined)
            {
                if (__pauseOnDuck) _maxVoice.__Resume();
                _maxVoice.__Duck(1, __rateOfChange, __VINYL_DUCK.__DO_NOTHING);
            }
        }
    }
    
    static __ExportJSON = function()
    {
        var _struct = {
            duck: __duckName,
        };
        
        _struct.duckedGain   = __duckedGain;
        _struct.rateOfChange = __rateOfChange;
        _struct.pauseOnDuck  = __pauseOnDuck;
        
        if (__duckedGain != 0) _struct.duckedGain = __duckedGain;
        if (__rateOfChange != __VINYL_DEFAULT_DUCK_RATE_OF_GAIN) _struct.rateOfChange = __rateOfChange;
        if (__pauseOnDuck != __VINYL_DEFAULT_DUCK_RATE_OF_GAIN) _struct.pauseOnDuck = __pauseOnDuck;
        
        return _struct;
    }
    
    static __ExportGML = function(_buffer, _indent)
    {
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "{\n");
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "    duck: \"");
        buffer_write(_buffer, buffer_text, __duckName);
        buffer_write(_buffer, buffer_text, "\",\n");
        
        if (__duckedGain != 1)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    duckedGain: ");
            buffer_write(_buffer, buffer_text, __duckedGain);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (__rateOfChange != __VINYL_DEFAULT_DUCK_RATE_OF_GAIN)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    rateOfChange: ");
            buffer_write(_buffer, buffer_text, __rateOfChange);
            buffer_write(_buffer, buffer_text, ",\n");
        }
        
        if (not __pauseOnDuck)
        {
            buffer_write(_buffer, buffer_text, _indent);
            buffer_write(_buffer, buffer_text, "    pauseOnDuck: false,\n");
        }
        
        buffer_write(_buffer, buffer_text, _indent);
        buffer_write(_buffer, buffer_text, "},\n");
    }
}

function __VinylImportDuckJSON(_json)
{
    if (VINYL_SAFE_JSON_IMPORT)
    {
        var _variableNames = struct_get_names(_json);
        var _i = 0;
        repeat(array_length(_variableNames))
        {
            switch(_variableNames[_i])
            {
                case "duck":
                case "duckedGain":
                case "rateOfChange":
                case "pauseOnDuck":
                break;
                
                default:
                    __VinylError("Duck \"", _json, "\" property .", _variableNames[_i], " not supported");
                break;
            }
            
            ++_i;
        }
    }
    
    VinylSetupDuck(_json.duck, _json[$ "duckedGain"], _json[$ "rateOfChange"], _json[$ "pauseOnDuck"]);
    
    return _json.duck;
}