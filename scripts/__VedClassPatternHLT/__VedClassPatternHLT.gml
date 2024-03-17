// Feather disable all

function __VedClassPatternHLT() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    
    __soundHead   = undefined;
    __soundLoop   = undefined;
    __soundTail   = undefined;
    __gainForce   = false;
    __gain        = [1, 1];
    __gainOption  = __VED_OPTION_UNSET;
    
    static __CompilePlay = function(_buffer)
    {
        
    }
    
    static __Serialize = function(_array)
    {
        array_push(_array, {
            name: __name,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name = _data.name;
    }
    
    static __SetGain = function(_value)
    {
        if (not array_equals(_value, __gain))
        {
            __gain = variable_clone(_value);
            
            //If the two values have inverted then swap 'em over
            if (__gain[0] > __gain[1])
            {
                var _temp = __gain[0];
                __gain[0] = __gain[1];
                __gain[1] = _temp;
            }
        }
    }
    
    static __SetGainOption = function(_value)
    {
        if (_value != __gainOption)
        {
            __gainOption = _value;
            if (__gainOption == __VED_OPTION_MULTIPLY) __SetGain([__gain[0], __gain[0]]);
        }
    }
    
    static __SetGainForce = function(_value)
    {
        if (_value != __gainForce)
        {
            __gainForce = _value;
        }
    }
    
    static __GetAbbreviation = function()
    {
        return "HLT";
    }
    
    static __BuildUI = function(_multiselector)
    {
        var _soundArray = _system.__project.__libSound.__GetNameArray();
        
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        
        ImGui.Text("Head-Loop-Tail pattern");
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Pattern", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 50))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Force Gain");
            ImGui.TableSetColumnIndex(1);
            __SetGainForce(ImGui.Checkbox("##Force Gain", __gainForce));
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            
            var _originalOption = __gainOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Gain Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_optionArray))
                {
                    var _optionName = _optionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Gain Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetGainOption(_optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            switch(__gainOption)
            {
                case __VED_OPTION_UNSET:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.BeginDisabled(true);
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, 1, 0.01, 2);
                    ImGui.EndDisabled();
                break;
                
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, __gain[0], 0.01, 2);
                    __SetGain([_newValue, _newValue]);
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__gain);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Gain " + __name, _newValue, 0.01, 2);
                    __SetGain(_newValue);
                break;
            }
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Sounds", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 70))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("",   ImGuiTableColumnFlags.WidthFixed, 30);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 40);
            
            //Head
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Head");
            
            ImGui.TableSetColumnIndex(1);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Head Combobox", __soundHead ?? "<no head sound>", ImGuiComboFlags.HeightLarge))
            {
                var _i = 0;
                repeat(array_length(_soundArray))
                {
                    var _soundName = _soundArray[_i];
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundHead == _soundName))
                    {
                        __soundHead = _soundName;
                    }
                
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear")) __soundHead = undefined;
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            
            ImGui.TableSetColumnIndex(1);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Loop Combobox", __soundLoop ?? "<no loop sound>", ImGuiComboFlags.HeightLarge))
            {
                var _i = 0;
                repeat(array_length(_soundArray))
                {
                    var _soundName = _soundArray[_i];
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundLoop == _soundName))
                    {
                        __soundLoop = _soundName;
                    }
                
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear")) __soundLoop = undefined;
            
            //Tail
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Tail");
            
            ImGui.TableSetColumnIndex(1);
            __VED_NEXT_UI_FILLS_WIDTH
            if (ImGui.BeginCombo("##Tail Combobox", __soundTail ?? "<no tail sound>", ImGuiComboFlags.HeightLarge))
            {
                var _i = 0;
                repeat(array_length(_soundArray))
                {
                    var _soundName = _soundArray[_i];
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundTail == _soundName))
                    {
                        __soundTail = _soundName;
                    }
                
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear")) __soundTail = undefined;
            
            ImGui.EndTable();
        }
    }
}