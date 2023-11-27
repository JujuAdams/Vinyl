// Feather disable all

/// @param tremolo

function __VinylTremoloShapeToName(_tremolo)
{
    static _lookup = undefined;
    if (_lookup == undefined)
    {
        _lookup = {};
        _lookup[$ AudioLFOType.Sine       ] = "Sine";
        _lookup[$ AudioLFOType.Square     ] = "Square";
        _lookup[$ AudioLFOType.Triangle   ] = "Triangle";
        _lookup[$ AudioLFOType.Sawtooth   ] = "Sawtooth";
        _lookup[$ AudioLFOType.InvSawtooth] = "InvSawtooth";
    }
    
    var _name = _lookup[$ _tremolo];
    if (_name == undefined) __VinylError("Tremolo type \"", _tremolo, "\" not recognised");
    return _name;
}