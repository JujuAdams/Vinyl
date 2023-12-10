// Feather disable all

/// @param name

function __VinylNameToTremoloShape(_name)
{
    static _lookup = {
        "Sine":            AudioLFOType.Sine,
        "Square":          AudioLFOType.Square,
        "Triangle":        AudioLFOType.Triangle,
        "Sawtooth":        AudioLFOType.Sawtooth,
        "InverseSawtooth": AudioLFOType.InvSawtooth,
    };
    
    var _tremolo = _lookup[$ _name];
    if (_tremolo == undefined) __VinylError("Tremolo name \"", _name, "\" not recognised");
    return _tremolo;
}