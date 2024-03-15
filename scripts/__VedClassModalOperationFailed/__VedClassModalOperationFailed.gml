// Feather disable all

function __VedClassModalOperationFailed() : __VedClassModal() constructor
{
    __handle = "Operation Failed";
    
    static __FirstTime = function()
    {
        ImGui.OpenPopup(__handle);
        ImGui.SetNextWindowPos(window_get_width()/2, window_get_height ()/2, ImGuiCond.Appearing, 0.5, 0.5);
    }
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("Operation on \"", __path, "\" failed."));
            
            ImGui.Separator();
            
            if (ImGui.Button("OK")) __Close();
            
            ImGui.EndPopup();
        }
    }
}