/// @param name

function VinylLibPlay(_name)
{
    var _pattern = global.__vinylLibraryMap[? _name];
    if (!VinylIsPattern(_pattern))
    {
        __VinylError("Library pattern \"", _name, "\" has not been defined");
    }
    
    return _pattern.Play();
}