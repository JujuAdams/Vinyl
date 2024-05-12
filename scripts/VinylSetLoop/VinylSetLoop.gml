// Feather disable all

/// @param voice
/// @param state

function VinylSetLoop(_voice, _state)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_sound_loop(_voice, _state);
    }
    else
    {
        return _voiceStruct.__SetLoop(_state);
    }
}