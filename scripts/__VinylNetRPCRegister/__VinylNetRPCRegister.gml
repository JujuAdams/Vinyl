// Feather disable all

/// @param name
/// @param function

function __VinylNetRPCRegister(_name, _function)
{
    static _system = __VinylSystem();
    if (not VINYL_LIVE_EDIT) return;
    
    _system.__rpcDict[$ _name] = _function;
}