// Feather disable all

/// @param voice

function VinylPause(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_pause_sound(_voice);
    }
    else
    {
        _voiceStruct.__Pause();
    }
}