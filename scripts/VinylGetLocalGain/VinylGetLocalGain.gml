// Feather disable all

/// @param voice

function VinylGetLocalGain(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (_voiceStruct == undefined)
    {
        return audio_sound_get_gain(_voice);
    }
    else
    {
        return _voiceStruct.__gainLocal;
    }
}