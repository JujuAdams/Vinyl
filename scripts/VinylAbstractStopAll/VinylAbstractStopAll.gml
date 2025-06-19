// Feather disable all

function VinylAbstractStopAll()
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _array = ds_map_values_to_array(_voiceToStructMap);
    var _i = 0;
    repeat(array_length(_array))
    {
        if (is_instanceof(_array[_i], __VinylClassVoiceAbstract))
        {
            _array[_i].__Stop();
        }
        
        ++_i;
    }
}