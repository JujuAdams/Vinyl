// Feather disable all

/// @param voice

function VinylIsPaused(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_is_paused(_voice);
    }
    else
    {
        return _voice.__IsPaused();
    }
}