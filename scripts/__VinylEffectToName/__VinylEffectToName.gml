// Feather disable all

/// @param effectType

function __VinylEffectToName(_effect)
{
    static _lookup = undefined;
    if (_lookup == undefined)
    {
        _lookup = {};
        _lookup[$ string(undefined                 )] = "None";
        _lookup[$ string(AudioEffectType.Bitcrusher)] = "Bitcrusher";
        _lookup[$ string(AudioEffectType.Delay     )] = "Delay";
        _lookup[$ string(AudioEffectType.Gain      )] = "Gain";
        _lookup[$ string(AudioEffectType.HPF2      )] = "HPF2";
        _lookup[$ string(AudioEffectType.LPF2      )] = "LPF2";
        _lookup[$ string(AudioEffectType.Reverb1   )] = "Reverb1";
        _lookup[$ string(AudioEffectType.Tremolo   )] = "Tremolo";
        _lookup[$ string(AudioEffectType.LoShelf   )] = "LoShelf";
        _lookup[$ string(AudioEffectType.HiShelf   )] = "HiShelf";
        _lookup[$ string(AudioEffectType.EQ        )] = "EQ";
    }
    
    if (not variable_struct_exists(_lookup, string(_effect)))
    {
        __VinylError("Effect type \"", _effect, "\" not recognised");
    }
    
    return _lookup[$ string(_effect)];
}