// Feather disable all

/// @param target
/// @param newConstructor

function __VinylPatternChange(_target, _newConstructor)
{
    var _oldStatic = static_get(_target);
    var _newStatic = static_get(_newConstructor);
    
    _target.__Unset(_newStatic);
    static_set(_target, _newStatic);
    _target.__Reset(_oldStatic);
    _target.__document.__Save();
}