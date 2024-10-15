// Feather disable all

/// Sets the fade in rate for audio played by a queue. A value of 0 will cause sounds to be
/// played without fading in.
/// 
/// @param voice
/// @param [fadeInRate=VINYL_DEFAULT_FADE_IN_RATE]

function VinylQueueSetFadeIn(_voice, _fadeInRate = VINYL_DEFAULT_FADE_IN_RATE)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    _voiceStruct.__fadeInRate = _fadeInRate;
}