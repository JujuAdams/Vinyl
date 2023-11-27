// Feather disable all

/// @param name

function __VinylNameToEffect(_name)
{
    static _lookup = {
        Bitcrusher: AudioEffectType.Bitcrusher,
        Delay:      AudioEffectType.Delay,
        Gain:       AudioEffectType.Gain,
        HPF2:       AudioEffectType.HPF2,
        LPF2:       AudioEffectType.LPF2,
        Reverb1:    AudioEffectType.Reverb1,
        Tremolo:    AudioEffectType.Tremolo,
        PeakEQ:     AudioEffectType.PeakEQ,
        LoShelf:    AudioEffectType.LoShelf,
        HiShelf:    AudioEffectType.HiShelf,
        EQ:         AudioEffectType.EQ,
    };
    
    var _effect = _lookup[$ _name];
    if (_effect == undefined) __VinylError("Effect name \"", _name, "\" not recognised");
    return _effect;
}