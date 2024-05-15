// Feather disable all

/// Returns whether the target voice is set to loop.
/// 
/// @param voice

function VinylGetLoop(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        return audio_sound_get_loop(_voice);
    }
    else
    {
        return _voiceStruct.__GetLoop();
    }
}