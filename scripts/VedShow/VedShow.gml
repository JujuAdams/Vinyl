// Feather disable all

function VinylEditorShow()
{
    static _editor = __VinylGlobalData().__editor;
    
    if (not __VED_ENABLED)
    {
        if (__VinylGetRunningFromIDE())
        {
            __VinylError("Cannot open the editor\n- Check VINYL_EDITOR_ENABLED is set to <true>\n- Editor is only supported on Windows");
        }
        
        return;
    }
    
    _editor.__showing = true;
}