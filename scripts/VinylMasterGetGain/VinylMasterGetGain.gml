/// Returns the master gain for Vinyl.

function VinylMasterGetGain()
{
    static _system = __VinylSystem();
    
    return _system.__masterGain;
}