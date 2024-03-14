// Feather disable all

function __VedClassModalIdentifyProjectFailed() : __VedClassModal() constructor
{
    __handle = "Identify Mismatch";
    
    static __FirstTime = function()
    {
        ImGui.OpenPopup(__handle);
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("This project file does not match the identifier for this game version.\nident=\"", __receivedIdent, "\""));
            
            ImGui.Separator();
            
            if (ImGui.Button("Try Again"))
            {
                __Close();
                __VedModalOpen(__VedClassModalIdentifyProjectSuccess).__receivedIdent = __receivedIdent;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Abort Connection")) __Close();
            
            ImGui.EndPopup();
        }
    }
}