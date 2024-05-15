// Feather disable all

function __VinylResolveChanges()
{
    static _toUpdateArray     = __VinylSystem().__toUpdateArray;
    static _voiceCleanUpArray = __VinylSystem().__voiceCleanUpArray;
    static _voiceUpdateArray  = __VinylSystem().__voiceUpdateArray;
    
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
    
    array_resize(_toUpdateArray, 0);
}