// Feather disable all

function __VedClassPatternBlend() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    
    __soundDict   = {};
    __soundArray  = [];
    __gainForce   = false;
    __gain        = 1;
    __gainOption  = __VED_OPTION_UNSET;
    
    static __CompilePlay = function(_buffer)
    {
        //TODO
    }
    
    static __CompilePattern = function(_buffer)
    {
        //TODO
    }
    
    static __CompileName = function(_buffer)
    {
        buffer_write(_buffer, buffer_text, $"        _data[$ \"{VED_GENERATED_ASSET_PREFIX}{__name}\"] = {VED_GENERATED_ASSET_PREFIX}{__name};\n");
    }
    
    static __Serialize = function(_array)
    {
        array_push(_array, {
            type:       __VED_PATTERN_TYPE_BLEND,
            name:       __name,
            sounds:     __soundArray,
            gainForce:  __gainForce,
            gain:       __gain,
            gainOption: __gainOption,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name        = _data.name;
        __soundArray  = _data[$ "sounds"    ] ?? [];
        __gainForce   = _data[$ "gainForce" ] ?? false;
        __gain        = _data[$ "gain"      ] ?? [1, 1];
        __gainOption  = _data[$ "gainOption"] ?? __VED_OPTION_UNSET;
        
        var _i = 0;
        repeat(array_length(__soundArray))
        {
            __soundDict[__soundArray[_i]] = true;
            ++_i;
        }
    }
    
    static __BroadcastChange = function()
    {
        __VedNetRPC("VinylCreateBlend", __soundArray, __gainForce, __gain, VED_GENERATED_ASSET_PREFIX + __name);
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
        return "Bld";
    }
    
    static __BuildUI = function(_multiselector)
    {
        var _soundArray = _system.__project.__libSound.__GetNameArray();
        
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY];
        
        ImGui.Text("Blend pattern");
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Pattern", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 70))
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
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, __gain, 0.01, 2);
                    __SetGain([_newValue, _newValue]);
                break;
            }
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        
        ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX() - 100);
        if (ImGui.BeginCombo("##Sound Combobox", "Add Sound", ImGuiComboFlags.HeightLarge | ImGuiComboFlags.WidthFitPreview))
        {
            var _i = 0;
            repeat(array_length(_soundArray))
            {
                var _soundName = _soundArray[_i];
                
                var _oldValue = variable_struct_exists(__soundDict, _soundName);
                var _newValue = (ImGui.Checkbox(_soundName + "##Selectable", _oldValue))
                
                if (_oldValue != _newValue)
                {
                    if (_newValue)
                    {
                        array_push(__soundArray, _soundName);
                        array_sort(__soundArray, true);
                        __soundDict[$ _soundName] = true;
                    }
                    else
                    {
                        var _index = __VedArrayFindIndex(__soundArray, _soundName);
                        if (_index != undefined) array_delete(__soundArray, _index, 1);
                        variable_struct_remove(__soundDict, _soundName);
                    }
                }
                
                ++_i;
            }
            
            ImGui.EndCombo();
        }
        
        ImGui.SameLine();
        
        if (ImGui.Button("Clear"))
        {
            __VedModalOpen(__VedClassModalCloseProject);
        }
        
        if (ImGui.BeginTable("Sounds", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, ImGui.GetContentRegionAvailY()))
        {
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 50);
            
            if (array_length(__soundArray) <= 0)
            {
                ImGui.Text("To add sounds to this pattern, use the combobox above");
            }
            else
            {
                var _i = 0;
                repeat(array_length(__soundArray))
                {
                    var _name = __soundArray[_i];
                    
                    ImGui.TableNextRow();
                    ImGui.TableSetColumnIndex(0);
                    ImGui.Text(_name);
                    
                    ImGui.TableSetColumnIndex(1);
                    if (ImGui.Button("Delete##" + string(_i)))
                    {
                        array_delete(__soundArray, _i, 1);
                        variable_struct_remove(__soundDict, _name);
                    }
                    else
                    {
                        ++_i;
                    }
                }
            }
            
            ImGui.EndTable();
        }
    }
}