// Feather disable all

/// Returns the target queue's behaviour.
/// 
/// @param voice

function VinylQueueGetBehaviour(_voice)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__behaviour;
}