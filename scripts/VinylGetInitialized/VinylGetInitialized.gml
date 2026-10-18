function VinylGetInitialized()
{
    static _system = __VinylSystem();
    
    return _system.__initialized;
}