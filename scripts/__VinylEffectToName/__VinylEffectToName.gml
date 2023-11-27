// Feather disable all

/// @param effectType

function __VinylEffectToName(_effect)
{
    static _lookup = undefined;
    if (_lookup == undefined)
    {
        _lookup = {};
        _lookup[$ AudioEffectType.Bitcrusher] = "Bitcrusher";
        _lookup[$ AudioEffectType.Delay     ] = "Delay";
        _lookup[$ AudioEffectType.Gain      ] = "Gain";
        _lookup[$ AudioEffectType.HPF2      ] = "HPF2";
        _lookup[$ AudioEffectType.LPF2      ] = "LPF2";
        _lookup[$ AudioEffectType.Reverb1   ] = "Reverb1";
        _lookup[$ AudioEffectType.Tremolo   ] = "Tremolo";
        _lookup[$ AudioEffectType.LoShelf   ] = "LoShelf";
        _lookup[$ AudioEffectType.HiShelf   ] = "HiShelf";
        _lookup[$ AudioEffectType.EQ        ] = "EQ";
    }
    
    var _name = _lookup[$ _effect];
    if (_name == undefined) __VinylError("Effect type \"", _effect, "\" not recognised");
    return _name;
}