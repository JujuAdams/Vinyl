// Feather disable all

function __VedClassModalCloseProject() : __VedClassModal() constructor
{
    __handle = "Close Editor?";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("Are you sure you want to close the editor without saving?");
            
            ImGui.Separator();
            
            if (ImGui.Button("Lose all changes"))
            {
            	__Close();
                VedClose();
                return;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Keep working")) __Close();
            
            ImGui.EndPopup();
        }
    }
}