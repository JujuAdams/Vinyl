// Feather disable all

/// @param voice

function VinylPause(_voice)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_pause_sound(_voice);
    }
    else
    {
        _voiceStruct.__Pause();
    }
}