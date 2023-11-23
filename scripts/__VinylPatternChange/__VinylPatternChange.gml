// Feather disable all

/// @param target
/// @param newConstructor

function __VinylPatternChange(_target, _newConstructor)
{
    _target.__Unset();
    static_set(_target, static_get(_newConstructor));
    _target.__Reset();
    _target.__document.__Save();
}