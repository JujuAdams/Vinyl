// Feather disable all

function __VinylEditorDraw()
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.__Render();
}