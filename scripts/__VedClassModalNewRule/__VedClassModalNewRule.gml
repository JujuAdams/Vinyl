// Feather disable all

function __VedClassModalNewRule() : __VedClassModal() constructor
{
    __handle = "New Rule";
    
    __ruleName = "";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            var _libRule = _system.__project.__libRule;
            
            ImGui.Text("Please enter the name of the new rule.");
            
            __ruleName = ImGui.InputTextWithHint("##Rule Name", "e.g. Long sound OGG", __ruleName);
            var _conflict = _libRule.__Exists(__ruleName);
            if (_conflict)
            {
                ImGui.SameLine(undefined, 23);
                ImGui.TextColored("Conflict!", __VED_COLOUR_RED);
            }
            
            ImGui.Separator();
            
            ImGui.BeginDisabled(_conflict || (string_length(__ruleName) <= 2));
            if (ImGui.Button("Create"))
            {
                _system.__project.__EnsureRule(__ruleName);
                __Close();
            }
            ImGui.EndDisabled();
            
            ImGui.SameLine(undefined, 30);
            if (ImGui.Button("Cancel")) __Close();
            
            ImGui.EndPopup();
        }
    }
}