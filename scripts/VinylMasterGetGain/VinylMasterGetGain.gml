// Feather disable all

function VinylMasterGetGain()
{
    static _system = __VinylSystem();
    return _system.__masterGain;
}