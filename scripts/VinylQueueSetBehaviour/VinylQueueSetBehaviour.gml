// Feather disable all

/// Sets the target queue's behaviour. Please see VinylQueueCreate() for more information.
/// 
/// @param voice
/// @param behaviour
/// @param [setForPlaying=true]

function VinylQueueSetBehaviour(_voice, _behaviour, _setForPlaying = true)
{
    static _voiceLookUpMap = __VinylSystem().__voiceLookUpMap;
    
    var _voiceStruct = _voiceLookUpMap[? _voice];
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return _voiceStruct.__SetBehaviour(_behaviour, _setForPlaying);
}