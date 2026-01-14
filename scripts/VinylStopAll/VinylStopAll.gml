// Feather disable all

/// Convenience function to stop all audio currently playing. If the optional parameter
/// `clearQueues` is set to `true` then all queues will have their contents cleared which will
/// prevent queues from playing their next track after all audio has been stopped.
/// 
/// @param [clearQueues=true]

function VinylStopAll(_clearQueues = true)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    
    audio_stop_all();
    
    if (_clearQueues)
    {
        //Ugly loop to find queue arrays and clear them out
        var _key = ds_map_find_first(_voiceToStructMap);
        repeat(ds_map_size(_voiceToStructMap))
        {
            var _voiceStruct = _voiceToStructMap[? _key];
            if (is_instanceof(_voiceStruct, __VinylClassVoiceQueue))
            {
                array_resize(_voiceStruct.__soundArray, 0);
            }
            
            _key = ds_map_find_next(_voiceToStructMap, _key);
        }
    }
    
    array_resize(_voiceUpdateArray, 0);
    ds_map_clear(_voiceToStructMap);
}