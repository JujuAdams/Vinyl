// Feather disable all

/// @param voice

function VinylStop(_voice)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_stop_sound(_voice);
    }
    else
    {
        _voiceStruct.__Stop();
    }
}