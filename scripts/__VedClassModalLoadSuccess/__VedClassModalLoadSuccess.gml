// Feather disable all

function __VedClassModalLoadSuccess() : __VedClassModal() constructor
{
    __handle = "Project Loaded";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("Successfully loaded \"", __path, "\"."));
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) __Close();
            
            ImGui.EndPopup();
        }
    }
}