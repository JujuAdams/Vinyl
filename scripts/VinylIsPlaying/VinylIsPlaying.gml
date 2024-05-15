// Feather disable all

/// Returns if the target voice is currently playing.
/// 
/// @param voice

function VinylIsPlaying(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return audio_is_playing(_voice);
    }
    else
    {
        return _voiceStruct.__IsPlaying();
    }
}