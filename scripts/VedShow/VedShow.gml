// Feather disable all

function VedShow()
{
    static _system = __VedSystem();
    
    if (not __VED_ENABLED)
    {
        if (__VED_RUNNING_FROM_IDE)
        {
            __VinylError("Cannot open the editor\n- Check VED_ENABLED is set to <true>\n- Editor is only supported on Windows");
        }
        
        return;
    }
    
    _system.__showing = true;
}