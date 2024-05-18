// Feather disable all

/// @param duckName
/// @param duckedGain
/// @param rateOfChange
/// @param pauseOnDuck

function __VinylClassDuck(_duckName, _duckedGain, _rateOfChange, _pauseOnDuck) constructor
{
    __duckName     = _duckName;
    __duckedGain   = _duckedGain;
    __rateOfChange = _rateOfChange;
    __pauseOnDuck  = _pauseOnDuck;
    
    __maxPriority   = -infinity;
    __voiceArray    = [];
    __priorityArray = [];
    
    
    
    
    
    static __UpdateSetup = function(_duckedGain, _rateOfChange, _pauseOnDuck)
    {
        __duckedGain   = _duckedGain;
        __rateOfChange = _rateOfChange;
        __pauseOnDuck  = _pauseOnDuck;
        
        //Update duck targets
        var _i = 0;
        repeat(array_length(__voiceArray))
        {
            if (__priorityArray[_i] < __maxPriority)
            {
                __voiceArray[_i].__Duck(__duckedGain, __rateOfChange, __pauseOnDuck? __VINYL_DUCK.__PAUSE : __VINYL_DUCK.__DO_NOTHING);
            }
            
            ++_i;
        }
    }
    
    static __Push = function(_priority, _voice, _onInstantiate)
    {
        var _priorityArray = __priorityArray;
        var _voiceArray    = __voiceArray;
        
        if (_priority < __maxPriority)
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _voice, " to stack \"", __duckName, "\" with lower priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            var _voiceStruct = __VinylEnsureSoundVoice(_voice);
            _voiceStruct.__Duck(__duckedGain, _onInstantiate? infinity : __rateOfChange, __pauseOnDuck? __VINYL_DUCK.__PAUSE : __VINYL_DUCK.__DO_NOTHING);
            
            //Try to find an existing voice to replace
            var _index = array_get_index(_priorityArray, _priority);
            if (_index >= 0)
            {
                if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(_voiceArray[_i], " on stack \"", __duckName, "\" shares priorty ", _priority, ", replacing it");
                
                //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                _voiceArray[_i].__FadeOut(__rateOfChange);
                _voiceArray[_i] = _voiceStruct;
            }
            else
            {
                if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _voice, " to stack \"", __duckName, "\"");
                
                //If no voice exists to replace, add the incoming voice
                array_push(_voiceArray, _voiceStruct);
                array_push(_priorityArray, _priority);
            }
        }
        else //priority >= maxPriority
        {
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Pushing ", _voice, " to stack \"", __duckName, "\" with sufficient priorty (", _priority, ") versus max (", __maxPriority, ")");
            
            __maxPriority = _priority;
            
            var _i = 0;
            repeat(array_length(_priorityArray))
            {
                var _existingPriority = _priorityArray[_i];
                if (_existingPriority < _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(_voiceArray[_i], " on stack \"", __duckName, "\" has lesser priorty (", _existingPriority, ") than incoming (", _priority, ")");
                    
                    //We found an existing voice with a lower priority - duck the existing voice
                    _voiceArray[_i].__Duck(__duckedGain, __rateOfChange, __pauseOnDuck? __VINYL_DUCK.__PAUSE : __VINYL_DUCK.__DO_NOTHING);
                }
                else if (_existingPriority == _priority)
                {
                    if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace(_voiceArray[_i], " on stack \"", __duckName, "\" shares priorty ", _priority, ", replacing it");
                    
                    //We found an existing voice with the same priority - fade out the existing voice and replace with ourselves
                    _voiceArray[_i].__FadeOut(__rateOfChange);
                    _voiceArray[_i] = _voiceStruct;
                    return;
                }
                
                ++_i;
            }
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Adding ", _voice, " to stack \"", __duckName, "\"");
            
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
}
