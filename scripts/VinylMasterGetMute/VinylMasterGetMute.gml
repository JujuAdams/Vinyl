function VinylMasterGetMute()
{
    static _system = __VinylSystem();
    
    return _system.__masterMute;
}