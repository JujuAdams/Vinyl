// Feather disable all

function __VedClassModalOperationFailed() : __VedClassModal() constructor
{
    __handle = "Operation Failed";
    
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