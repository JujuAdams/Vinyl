// Feather disable all

/// Sets the target voice to loop or not loop. If a head-loop-tail voice is targeted then it is
/// not possible to change the loop behaviour of the head or tail sound. If the loop sound is set
/// to not loop then the tail sound will play after the loop sound has played through.
/// 
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