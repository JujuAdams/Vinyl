// Feather disable all

function __VedClassModalCreateSuccess() : __VedClassModal() constructor
{
    __handle = "Project Created";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("Successfully created \"", __path, "\"."));
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) __Close();
            
            ImGui.EndPopup();
        }
    }
}