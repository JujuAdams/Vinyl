// Feather disable all

function __VedClassModalNewAudioGroup() : __VedClassModal() constructor
{
    __handle = "New Audio Group";
    
    __audioGroupName = "";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            var _libAudioGroup = _system.__project.__libAudioGroup;
            
            ImGui.Text("Please enter the name of the new audio group.");
            
            __audioGroupName = ImGui.InputTextWithHint("##Audio Group Name", "e.g. agLavaWorld", __audioGroupName);
            var _conflict = _libAudioGroup.__Exists(__audioGroupName);
            if (_conflict)
            {
                ImGui.SameLine(undefined, 23);
                ImGui.TextColored("Conflict!", #FF5050);
            }
            
            ImGui.Separator();
            
            ImGui.BeginDisabled(_conflict || (string_length(__audioGroupName) <= 2));
            if (ImGui.Button("Create"))
            {
                _system.__project.__EnsureAudioGroup(__audioGroupName);
                _system.__project.__SaveAudioGroups();
                __Close();
            }
            ImGui.EndDisabled();
            
            ImGui.SameLine(undefined, 30);
            if (ImGui.Button("Cancel")) __Close();
            
            ImGui.EndPopup();
        }
    }
}