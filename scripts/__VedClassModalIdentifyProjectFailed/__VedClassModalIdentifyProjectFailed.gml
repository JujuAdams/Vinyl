// Feather disable all

function __VedClassModalIdentifyProjectFailed() : __VedClassModal() constructor
{
    __handle = "Identify Mismatch";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text(string_concat("This GameMaker project file does not match the identifier for this game version.\n(Expected ident=\"", __receivedIdent, "\")"));
            
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