// Feather disable all

function __VedClassModalIdentifyProjectSuccess() : __VedClassModal() constructor
{
    static __FirstTime = function()
    {
        ImGui.OpenPopup("Project Identified");
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal("Project Identified"))
        {
            ImGui.Text("The project file has been successfully identied.");
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) __Close();
            
            ImGui.EndPopup();
        }
    }
}