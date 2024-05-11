// Feather disable all

/// Immediately stops playback of a voice.
/// 
/// @param voice

function VinylStop(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_stop_sound(_voice);
    }
    else
    {
        _voiceStruct.__Stop();
    }
}