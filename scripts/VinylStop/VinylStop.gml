// Feather disable all

/// Immediately stops playback of a voice.
/// 
/// @param voice

function VinylStop(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (_voiceStruct == undefined)
    {
        audio_stop_sound(_voice);
    }
    else
    {
        _voiceStruct.__Stop();
    }
}