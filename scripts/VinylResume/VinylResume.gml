// Feather disable all

/// Resumes playback of a paused voice.
/// 
/// @param voice

function VinylResume(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_resume_sound(_voice);
    }
    else
    {
        _voiceStruct.__Resume();
    }
}