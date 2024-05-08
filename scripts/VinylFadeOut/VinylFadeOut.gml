// Feather disable all

/// @param voice
/// @param rateOfChange

function VinylFadeOut(_voice, _rateOfChange)
{
    static _voiceStructDict = __VinylSystem().__voiceStructDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceStructDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        audio_stop_sound(_voice);
    }
    else
    {
        _voiceStruct.__FadeOut(_rateOfChange);
    }
}