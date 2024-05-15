// Feather disable all

/// Pauses the target voice. Playback may be resumed by VinylResume() or VinylMixResumeVoices().
/// 
/// @param voice

function VinylPause(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        audio_pause_sound(_voice);
    }
    else
    {
        _voiceStruct.__Pause();
    }
}