// Feather disable all

function __VedClassModalNewPattern() : __VedClassModal() constructor
{
    __handle = "New Pattern";
    
    __patternName = "";
    __type = undefined;
    
    static __BuildUI = function()
    {
        static _patternOptions = [__VED_PATTERN_TYPE_SHUFFLE, __VED_PATTERN_TYPE_HEAD_LOOP_TAIL, __VED_PATTERN_TYPE_MULTI];
        
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            var _libPattern = _system.__project.__libPattern;
            
            ImGui.Text("Please enter the name and type of the new pattern.");
            
            __patternName = ImGui.InputTextWithHint("##Pattern Name", "e.g. Footstep", __patternName);
            var _conflict = _libPattern.__Exists(__patternName);
            if (_conflict)
            {
                ImGui.SameLine(undefined, 23);
                ImGui.TextColored("Conflict!", #FF5050);
            }
            
            var _i = 0;
            repeat(array_length(_patternOptions))
            {
                var _patternType = _patternOptions[_i];
                if (ImGui.RadioButton(_patternType, __type == _patternType)) __type = _patternType;
                ++_i;
            }
            
            ImGui.Separator();
            
            ImGui.BeginDisabled(_conflict || (string_length(__patternName) <= 2) || (__type == undefined));
            if (ImGui.Button("Create"))
            {
                _system.__project.__EnsurePattern(__patternName);
                __Close();
            }
            ImGui.EndDisabled();
            
            ImGui.SameLine(undefined, 30);
            if (ImGui.Button("Cancel")) __Close();
            
            ImGui.EndPopup();
        }
    }
}