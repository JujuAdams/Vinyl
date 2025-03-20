// Feather disable all

/// Convenience function to stop all audio currently playing.

function VinylStopAll()
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    static _voiceUpdateArray = __VinylSystem().__voiceUpdateArray;
    
    audio_stop_all();
    
    array_resize(_voiceUpdateArray, 0);
    ds_map_clear(_voiceToStructMap);
}