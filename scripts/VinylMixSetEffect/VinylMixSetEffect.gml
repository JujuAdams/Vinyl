/// Sets an effect for a mix group. Effects work the same as native GameMaker effects, please see
/// documentation for "AudioEffect Struct".
/// 
/// Mix groups may have a maximum of 4 effects applied. These effects will be applied to all audio
/// played on that mix group, including audio played through emitters (though all emitters must be
/// created with `VinylEmitterCreate()` to work properly). Mix group effects are applied after
/// emitter effects.
/// 
/// @param mixGroupIndex
/// @param index
/// @param effectStruct

function VinylMixSetEffect(_mixGroupIndex, _effectIndex, _effectStruct)
{
    if ((_effectIndex < 0) || (_effectIndex > 3))
    {
        __VinylTrace($"Effect index must be between 0 and 3 inclusive (was given {_effectIndex})");
        return;
    }
    
    var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
    if (_mixGroup != undefined)
    {
        return;
    }
    
    with(_mixGroup)
    {
        var _i = 0;
        repeat(array_length(__gmEmitterAndBusArray))
        {
            __gmEmitterAndBusArray[_i].__bus.effects[@ 4 + _effectIndex] = _effectStruct;
            ++_i;
        }
    }
}