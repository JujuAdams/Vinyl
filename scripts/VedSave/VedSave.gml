// Feather disable all

function VedSave()
{
    static _system = __VedSystem();
    
    if (_system.__project == undefined)
    {
        __VedLog("Cannot save, no project is loaded");
        return;
    }
    
    return _system.__project.__Save();
}