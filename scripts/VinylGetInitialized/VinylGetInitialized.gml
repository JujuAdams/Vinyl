/// Returns if Vinyl has been initialized. Vinyl is iniitialized by calling `VinylRequestInitialize()`.

function VinylGetInitialized()
{
    static _system = __VinylSystem();
    
    return _system.__initialized;
}