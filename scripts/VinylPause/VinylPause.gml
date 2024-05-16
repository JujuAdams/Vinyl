// Feather disable all

/// Pauses the target voice. Playback may be resumed by VinylResume() or VinylMixResumeVoices().
/// 
/// @param voice

function VinylPause(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        audio_pause_sound(_voice);
    }
    else
    {
        _voiceStruct.__Pause();
    }
}