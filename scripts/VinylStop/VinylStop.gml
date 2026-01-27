// Feather disable all

/// Immediately stops playback of a voice. Calling this function targeting an HLT voice will stop
/// the HLT voice entirely. If you'd like to move from the "loop" sound to the "tail" sound then
/// call `VinylSetLoop(..., false)`.
/// 
/// @param voice

function VinylStop(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (_voiceStruct == undefined)
    {
        if (_voice != undefined)
        {
            audio_stop_sound(_voice);
        }
    }
    else
    {
        _voiceStruct.__Stop();
    }
}