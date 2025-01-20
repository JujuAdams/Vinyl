// Feather disable all

/// Returns the number of sounds that are being played by a blend pattern voice. If the target
/// voice is not a blend pattern, this function returns 0.
/// 
/// @param voice

function VinylGetBlendMemberCount(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceBlend)) return 0;
    
    return _voiceStruct.__voiceCount;
}