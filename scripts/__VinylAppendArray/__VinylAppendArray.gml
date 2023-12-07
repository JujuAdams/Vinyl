// Feather disable all

/// @param source
/// @param destination

function __VinylAppendArray(_source, _destination)
{
    array_copy(_destination, array_length(_destination), _source, 0, array_length(_source));
}