// Feather disable all

/// @param name

function __VinylNameToEffect(_name)
{
    static _lookup = {
        None:       undefined,
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
    
    if (not variable_struct_exists(_lookup, _name))
    {
        __VinylError("Effect name \"", _name, "\" not recognised");
    }
    
    return _lookup[$ _name];
}