// Feather disable all

/// @param target
/// @param newConstructor

function __VinylPatternChange(_target, _newConstructor)
{
    static_set(_target, static_get(_newConstructor));
}