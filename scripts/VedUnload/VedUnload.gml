// Feather disable all

function VedUnload()
{
    static _system = __VedSystem();
    with(_system)
    {
        if (__project != undefined)
        {
            __project.__Unload();
            __project = undefined;
        }
        
        __windowsArray = [];
    }
}