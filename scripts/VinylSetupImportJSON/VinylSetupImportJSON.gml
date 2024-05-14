// Feather disable all

/// Imports a JSON that contains definitions for mixes, sounds, and patterns. This is sometimes
/// more convenient than writing lines of code.
/// 
/// You can read more about the JSON format that Vinyl expects in the "Vinyl Setup JSON Format"
/// note asset included with the library code.
/// 
/// @param json
/// @param [overwrite=true]

function __VinylSetupImportJSONInner(_json, _overwrite = true)
{
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
    if (VINYL_LIVE_EDIT) array_resize(_toUpdateArray, 0);
    
    var _result = __VinylSetupImportJSONInner(_json, _overwrite);
    
    if (VINYL_LIVE_EDIT)
    {
        //Strip out duplicates
        array_resize(_toUpdateArray, array_unique_ext(_toUpdateArray));
        
        //First phase - Convert updated patterns into currently playing voices that we need to update
        var _i = 0;
        repeat(array_length(_toUpdateArray))
        {
            var _pattern = _toUpdateArray[_i];
            
            switch(instanceof(_pattern))
            {
                case "__VinylClassPatternSound":
                    var _sound = _pattern.__sound;
                    
                    var _j = 0;
                    repeat(array_length(_voiceCleanUpArray))
                    {
                        _voiceCleanUpArray[_j].__QueueUpdateForSound(_sound);
                        ++_j;
                    }
                    
                    var _j = 0;
                    repeat(array_length(_voiceUpdateArray))
                    {
                        _voiceUpdateArray[_j].__QueueUpdateForSound(_sound);
                        ++_j;
                    }
                break;
                
                case "__VinylClassPatternShuffle":
                case "__VinylClassPatternBlend":
                    var _j = 0;
                    repeat(array_length(_voiceCleanUpArray))
                    {
                        if (_voiceCleanUpArray[_j].__pattern == _pattern)
                        {
                            array_push(_toUpdateArray, _voiceCleanUpArray[_j]);
                        }
                        
                        ++_j;
                    }
                break;
                
                case "__VinylClassPatternHLT":
                    var _j = 0;
                    repeat(array_length(_voiceUpdateArray))
                    {
                        if (_voiceUpdateArray[_j].__pattern == _pattern)
                        {
                            array_push(_toUpdateArray, _voiceUpdateArray[_j]);
                        }
                        
                        ++_j;
                    }
                break;
                
                default:
                    __VinylError("Unhandled first-tier update struct, instanceof = \"", instanceof(_pattern), "\"");
                break;
            }
            
            array_delete(_toUpdateArray, _i, 1);
        }
        
        //Strip out duplicates again
        array_resize(_toUpdateArray, array_unique_ext(_toUpdateArray));
        
        //Execute update calls for every voice that needs updating
        var _i = 0;
        repeat(array_length(_toUpdateArray))
        {
            var _voice = _toUpdateArray[_i];
            
            switch(instanceof(_voice))
            {
                case "__VinylClassVoiceSound":
                case "__VinylClassVoiceShuffle":
                case "__VinylClassVoiceHLT":
                case "__VinylClassVoiceBlend":
                case "__VinylClassVoiceQueue":
                    _voice.__UpdateFromPattern();
                break;
                
                default:
                    __VinylError("Unhandled second-tier update struct, instanceof = \"", instanceof(_pattern), "\"");
                break;
            }
            
            ++_i;
        }
        
        // HLT
        //
        //var _headChanged = (_newSoundHead != __soundHead);
        //var _loopChanged = (_newSoundLoop != __soundLoop);
        //var _tailChanged = (_newSoundTail != __soundTail);
        //
        //if (VINYL_LIVE_EDIT)
        //{
        //    var _i = 0;
        //    repeat(array_length(_voiceUpdateArray))
        //    {
        //        var _voiceStruct = _voiceUpdateArray[_i];
        //        if (_voiceStruct.__pattern == self)
        //        {
        //            _voiceStruct.__SetFromPattern(_headChanged, _loopChanged, _tailChanged);
        //        }
        //        
        //        ++_i;
        //    }
        //}
        
        // Blend
        //
        //var _soundsChanged = (not array_equals(_newSoundArray, __soundArray));
        //
        //if (VINYL_LIVE_EDIT)
        //{
        //    var _i = 0;
        //    repeat(array_length(_voiceCleanUpArray))
        //    {
        //        var _voiceStruct = _voiceCleanUpArray[_i];
        //        if (_voiceStruct.__pattern == self)
        //        {
        //            _voiceStruct.__SetFromPattern(_soundsChanged);
        //        }
        //        
        //        ++_i;
        //    }
        //}
        
        array_resize(_toUpdateArray, 0);
    }
    
    return _result;
}

function __VinylSetupImportJSONInner(_json, _overwrite)
{
    //TODO - Implement overwrite behaviour
    
    if (is_array(_json))
    {
        var _i = 0;
        repeat(array_length(_json))
        {
            __VinylSetupImportJSONInner(_json[_i], _overwrite);
            ++_i;
        }
    }
    else if (is_struct(_json))
    {
        if (struct_exists(_json, "shuffle"))
        {
            return __VinylImportShuffleJSON(_json);
        }
        else if (struct_exists(_json, "hlt"))
        {
            return __VinylImportHLTJSON(_json);
        }
        else if (struct_exists(_json, "blend"))
        {
            return __VinylImportBlendJSON(_json);
        }
        else if (struct_exists(_json, "sound"))
        {
            return __VinylImportSoundJSON(_json);
        }
        else if (struct_exists(_json, "mix"))
        {
            return __VinylImportMixGroupJSON(_json, _overwrite);
        }
        else if (struct_exists(_json, "metadata"))
        {
            return __VinylImportMetadataJSON(_json);
        }
        else
        {
            __VinylError("Struct could not be parsed, missing type information\nStruct should contain one of the following variables to indicate type:\n  .sound\n  .shuffle\n  .hlt\n  .blend\n  .mix");
        }
    }
    else
    {
        __VinylError("Datatype unsupported (", typeof(_json), ")");
    }
    
    return undefined;
}