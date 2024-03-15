// Feather disable all

function __VedClassModalNoIdent() : __VedClassModal() constructor
{
    __handle = "Incompatible Game";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("The target game is missing a Vinyl identifier.");
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) ImGui.CloseCurrentPopup();
            
            ImGui.EndPopup();
        }
    }
}