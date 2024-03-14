// Feather disable all

function __VedClassModalIdentifyProject() : __VedClassModal() constructor
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
            ImGui.Text("Please identify the project file associated with this game.");
            
            ImGui.Separator();
            
            if (ImGui.Button("Open File Browser"))
            {
                var _path = get_open_filename("*.*", ".json");
                if (_path != "")
                {
                    ImGui.CloseCurrentPopup();
                    
                    var _foundIdent = "1";
                    if (_foundIdent == __receivedIdent)
                    {
                        __VedModalOpen(__VedClassModalIdentifyProjectSuccess);
                    }
                    else
                    {
                        __VedModalOpen(__VedClassModalIdentifyProjectFailed).__receivedIdent = __receivedIdent;
                    }
                }
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Abort Connection")) ImGui.CloseCurrentPopup();
            
            ImGui.EndPopup();
        }
    }
}