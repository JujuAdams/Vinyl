// Feather disable all

function VinylEditorIsShowing()
{
    static _editor = __VinylGlobalData().__editor;
    
    return (__VinylGetEditorEnabled() && _editor.__showing);
}