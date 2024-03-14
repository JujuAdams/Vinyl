// Feather disable all

function __VedClassModalIdentifyProjectFailed() : __VedClassModal() constructor
{
    static __FirstTime = function()
    {
        ImGui.OpenPopup("Identify Project");
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal("Identify Project", undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("This project file is for a different version of the game.");
            
            ImGui.Separator();
            
            if (ImGui.Button("Try Again"))
            {
                ImGui.CloseCurrentPopup();
                __VedModalOpen(__VedClassModalIdentifyProjectSuccess).__receivedIdent = __receivedIdent;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Abort Connection")) ImGui.CloseCurrentPopup();
            
            ImGui.EndPopup();
        }
    }
}