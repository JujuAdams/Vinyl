// Feather disable all

function __VedClassModalNewPattern() : __VedClassModal() constructor
{
    __handle = "New Pattern";
    
    __patternName = "";
    __type = undefined;
    
    static __BuildUI = function()
    {
        static _patternOptions = [__VED_PATTERN_TYPE_SHUFFLE, __VED_PATTERN_TYPE_HEAD_LOOP_TAIL, __VED_PATTERN_TYPE_BLEND];
        
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            var _libPattern = _system.__project.__libPattern;
            
            ImGui.Text("Please enter the name and type of the new pattern.");
            
            __patternName = ImGui.InputTextWithHint("##Pattern Name", "e.g. Footstep", __patternName);
            
            if (VED_CAPITALIZE_PATTERN_FIRST_CHAR)
            {
                __patternName = string_upper(string_copy(__patternName, 1, 1)) + string_delete(__patternName, 1, 1);
            }
            
            var _disabled = false;
            if (string_length(__patternName) <= 2)
            {
                if ((not _disabled) && (string_length(__patternName) > 0))
                {
                    ImGui.SameLine(undefined, 23);
                    ImGui.TextColored("Too short!", __VED_COLOUR_RED);
                }
                
                _disabled = true;
            }
            
            var _firstChar = string_copy(__patternName, 1, 1);
            if (string_digits(_firstChar) == _firstChar)
            {
                if (not _disabled)
                {
                    ImGui.SameLine(undefined, 23);
                    ImGui.TextColored("Invalid!", __VED_COLOUR_RED);
                }
                
                _disabled = true;
            }
            
            if (string_pos(" ", __patternName) > 0)
            {
                if (not _disabled)
                {
                    ImGui.SameLine(undefined, 23);
                    ImGui.TextColored("Invalid!", __VED_COLOUR_RED);
                }
                
                _disabled = true;
            }
            
            if (_libPattern.__Exists(__patternName))
            {
                if (not _disabled)
                {
                    ImGui.SameLine(undefined, 23);
                    ImGui.TextColored("Conflict!", __VED_COLOUR_RED);
                }
                
                _disabled = true;
            }
            
            var _i = 0;
            repeat(array_length(_patternOptions))
            {
                var _patternType = _patternOptions[_i];
                if (ImGui.RadioButton(_patternType, __type == _patternType)) __type = _patternType;
                ++_i;
            }
            
            ImGui.Separator();
            
            ImGui.BeginDisabled(_disabled || (__type == undefined));
            if (ImGui.Button("Create"))
            {
                switch(__type)
                {
                    case __VED_PATTERN_TYPE_SHUFFLE:        var _constructor = __VedClassPatternShuffle; break;
                    case __VED_PATTERN_TYPE_HEAD_LOOP_TAIL: var _constructor = __VedClassPatternHLT;     break;
                    case __VED_PATTERN_TYPE_BLEND:          var _constructor = __VedClassPatternBlend;   break;
                    
                    default:
                        __VedError("Unhandled pattern type \"", __type, "\"");
                    break;
                }
                
                _system.__project.__EnsurePattern(__patternName, _constructor);
                __Close();
            }
            ImGui.EndDisabled();
            
            ImGui.SameLine(undefined, 30);
            if (ImGui.Button("Cancel")) __Close();
            
            ImGui.EndPopup();
        }
    }
}