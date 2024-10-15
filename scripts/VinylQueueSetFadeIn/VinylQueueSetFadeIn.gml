// Feather disable all

/// Sets the fade in rate for audio played by a queue. A value of 0 will cause sounds to be
/// played without fading in.
/// 
/// @param voice
/// @param fadeInRate

function VinylQueueSetFadeIn(_voice, _fadeInRate)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    _voiceStruct.__fadeInRate = _fadeInRate;
}