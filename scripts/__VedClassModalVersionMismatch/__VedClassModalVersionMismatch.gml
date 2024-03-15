// Feather disable all

function __VedClassModalVersionMismatch() : __VedClassModal() constructor
{
    __handle = "Version Mismatch";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("We are version ", __VED_VERSION, " but the connected game is version ", __receivedVersion, "."));
            
            ImGui.Separator();
            
            if (ImGui.Button("Abort Connection")) __Close();
            
            ImGui.EndPopup();
        }
    }
}