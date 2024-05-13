// Feather disable all

/// Returns whether the target voice is set to loop.
/// 
/// @param voice

function VinylGetLoop(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_sound_get_loop(_voice);
    }
    else
    {
        return _voiceStruct.__GetLoop();
    }
}