// Feather disable all

/// @param voice

function VinylIsPlaying(_voice)
{
    static _voiceDict = __VinylSystem().__voiceStructDict;
    
    var _voiceContext = struct_get_from_hash(_voiceDict, int64(_voice));
    if (_voiceContext == undefined)
    {
        return audio_is_playing(_voice);
    }
    else
    {
        return _voice.__IsPlaying();
    }
}