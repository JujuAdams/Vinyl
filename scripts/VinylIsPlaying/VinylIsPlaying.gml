// Feather disable all

/// @param voice

function VinylIsPlaying(_voice)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_is_playing(_voice);
    }
    else
    {
        return _voice.__IsPlaying();
    }
}