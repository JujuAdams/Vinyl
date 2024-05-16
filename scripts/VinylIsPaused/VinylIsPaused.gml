// Feather disable all

/// Returns if the target voice's playback is paused.
/// 
/// @param voice

function VinylIsPaused(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return audio_is_paused(_voice);
    }
    else
    {
        return _voice.__IsPaused();
    }
}