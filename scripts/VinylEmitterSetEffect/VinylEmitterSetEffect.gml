/// Sets an effect for an emitter created with `VinylCreateEmitter()`. Effects work the same as
/// native GameMaker effects, please see documentation for "AudioEffect Struct".
/// 
/// Vinyl emitters may have a maximum of 4 effects applied. These effects will be applied to all
/// audio played on the emitter regardless of what mix group is used for that piece of audio.
/// Emitter effects are applied before mix group effects.
/// 
/// @param emitter
/// @param effectIndex
/// @param effectStruct

function VinylEmitterSetEffect(_emitter, _effectIndex, _effectStruct)
{
    if ((_effectIndex < 0) || (_effectIndex > 3))
    {
        __VinylError($"Effect index must be an integer between 0 and 3 inclusive (got {_effectIndex})");
    }
    
    if (_emitter == undefined) return;
    
    _emitter.__bus.effects[@ _effectIndex] = _effectStruct;
}