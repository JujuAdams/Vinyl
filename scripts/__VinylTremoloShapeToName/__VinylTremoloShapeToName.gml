// Feather disable all

/// @param tremolo

function __VinylTremoloShapeToName(_tremolo)
{
    static _lookup = undefined;
    if (_lookup == undefined)
    {
        _lookup = {};
        _lookup[$ string(AudioLFOType.Sine       )] = "Sine";
        _lookup[$ string(AudioLFOType.Square     )] = "Square";
        _lookup[$ string(AudioLFOType.Triangle   )] = "Triangle";
        _lookup[$ string(AudioLFOType.Sawtooth   )] = "Sawtooth";
        _lookup[$ string(AudioLFOType.InvSawtooth)] = "InvSawtooth";
    }
    
    var _name = _lookup[$ string(_tremolo)];
    if (_name == undefined) __VinylError("Tremolo type \"", _tremolo, "\" not recognised");
    return _name;
}