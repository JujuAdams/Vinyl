// Feather disable all

/// Returns if the target voice is currently playing.
/// 
/// @param voice

function VinylIsPlaying(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_is_playing(_voice);
    }
    else
    {
        return _voice.__IsPlaying();
    }
}