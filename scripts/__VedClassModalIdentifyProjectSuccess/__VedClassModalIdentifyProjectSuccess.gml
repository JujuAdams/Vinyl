// Feather disable all

function __VedClassModalIdentifyProjectSuccess() : __VedClassModal() constructor
{
    __handle = "Project Identified";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle))
        {
            ImGui.Text("The project file has been successfully identied.");
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) __Close();
            
            ImGui.EndPopup();
        }
    }
}