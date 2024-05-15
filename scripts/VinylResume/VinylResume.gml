// Feather disable all

/// Resumes playback of a paused voice.
/// 
/// @param voice

function VinylResume(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        audio_resume_sound(_voice);
    }
    else
    {
        _voiceStruct.__Resume();
    }
}