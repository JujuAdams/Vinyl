// Feather disable all

/// Returns the array of sounds that are queued for the target queue voice. This queue does not
/// include the currently playing sound. This function returns a copy of the internal array that
/// the queue uses. Modifying the returned array will therefore not alter the queue's behaviour and
/// you will need to use VinylQueueSetArray() to "save" any changes you've made to the array.
/// 
/// @param voice

function VinylQueueGetArray(_voice)
{
    static _voiceLookUpDict = __VinylSystem().__voiceLookUpDict;
    
    if (_voice == undefined) return undefined;
    
    var _voiceStruct = struct_get_from_hash(_voiceLookUpDict, int64(_voice));
    if (not is_instanceof(_voiceStruct, __VinylClassVoiceQueue)) return undefined;
    
    return variable_clone(_voiceStruct.__soundArray);
}