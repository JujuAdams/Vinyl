// Feather disable all

/// Returns the fade in rate for audio played by a queue. If the queue doesn't exist then this
/// function will return `undefined`.
/// 
/// @param voice

function VinylQueueGetFadeIn(_voice)
{
    static _voiceToStructMap = __VinylSystem().__voiceToStructMap;
    
    var _voiceStruct = _voiceToStructMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__fadeInRate;
}