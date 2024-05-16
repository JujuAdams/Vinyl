// Feather disable all

/// Returns if the target voice is currently playing.
/// 
/// @param voice

function VinylIsPlaying(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return audio_is_playing(_voice);
    }
    else
    {
        return _voiceStruct.__IsPlaying();
    }
}