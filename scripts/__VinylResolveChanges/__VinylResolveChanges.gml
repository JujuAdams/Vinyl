// Feather disable all

/// @param replace

function __VinylResolveChanges(_replace)
{
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    static _soundDict         = __VinylSystem().__soundDict;
    static _patternDict       = __VinylSystem().__patternDict;
    
    //Strip out duplicates
    array_resize(_toUpdateArray, array_unique_ext(_toUpdateArray));
    
    if (_replace)
    {
        var _nameArray = struct_get_names(_soundDict);
        var _i = 0;
        repeat(array_length(_nameArray))
        {
            var _pattern = _soundDict[$ _nameArray[_i]];
            if (not array_contains(_toUpdateArray, _pattern)) _pattern.__ClearSetup();
            ++_i;
        }
        
        var _nameArray = struct_get_names(_patternDict);
        var _i = 0;
        repeat(array_length(_nameArray))
        {
            var _pattern = _patternDict[$ _nameArray[_i]];
            if (not array_contains(_toUpdateArray, _pattern)) _pattern.__ClearSetup();
            ++_i;
        }
    }
    
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
            
            case "__VinylClassPatternMix":
                var _array = _pattern.__voiceArray;
                array_copy(_toUpdateArray, array_length(_toUpdateArray), _array, 0, array_length(_array));
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
    
    array_resize(_toUpdateArray, 0);
}