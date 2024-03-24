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
        buffer_write(_buffer, buffer_text, $"        struct_set_from_hash(_data, {VED_GENERATED_ASSET_PREFIX}{__name}, function(_loop_UNUSED, _gainLocal, _pitchLocal)\n");
        buffer_write(_buffer, buffer_text,  "        {\n");
        buffer_write(_buffer, buffer_text, $"            static _pattern = struct_get_from_hash(__VinylGenPattern(), {VED_GENERATED_ASSET_PREFIX}{__name});\n");
        buffer_write(_buffer, buffer_text,  "            return (new __VinylClassVoiceBlend(_pattern)).__voiceTop;\n");
        buffer_write(_buffer, buffer_text,  "        });\n");
        buffer_write(_buffer, buffer_text,  "\n");
    }
    
    static __CompilePattern = function(_buffer)
    {
        var _soundArrayString = "[" + string_join_ext(", ", __soundArray) + "]";
        buffer_write(_buffer, buffer_text, $"        struct_set_from_hash(_data, {VED_GENERATED_ASSET_PREFIX}{__name}, new __VinylClassPatternBlend({VED_GENERATED_ASSET_PREFIX}{__name}, {_soundArrayString}, {__gainForce? "true" : "false"}, {__gain}));\n");
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
            __soundDict[$ __soundArray[_i]] = true;
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
    
    static __AddSound = function(_soundName)
    {
        array_push(__soundArray, _soundName);
        __soundDict[$ _soundName] = true;
        array_sort(__soundArray, true);
        
        __BroadcastChange();
    }
    
    static __DeleteSoundByName = function(_soundName)
    {
        var _index = __VedArrayFindIndex(__soundArray, _soundName);
        if (_index != undefined) array_delete(__soundArray, _index, 1);
        variable_struct_remove(__soundDict, _soundName);
        
        __BroadcastChange();
    }
    
    static __DeleteSoundByIndex = function(_index)
    {
        var _name = __soundArray[_index];
        array_delete(__soundArray, _index, 1);
        variable_struct_remove(__soundDict, _name);
        
        __BroadcastChange();
    }
    
    static __ClearSoundArray = function()
    {
        array_resize(__soundArray, 0);
        
        __BroadcastChange();
    }
    
    static __GetAbbreviation = function()
    {
        return "Bld";
    }
    
    static __BuildUI = function(_multiselector, _dictionary)
    {
        var _soundArray = _system.__project.__libSound.__GetNameArray();
        
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY];
        
        ImGui.Text("Blend pattern");
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Pattern", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 69))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 24);
            ImGui.Text("Gain");
            
            ImGui.TableSetColumnIndex(1);
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
                    __SetGain(_newValue);
                break;
            }
            
            if (ImGui.RadioButton("No Change##Gain", __gainOption == __VED_OPTION_UNSET))
            {
                _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                {
                    _struct.__SetGainOption(__VED_OPTION_UNSET);
                });
            }
            ImGui.SameLine(undefined, 20);
            if (ImGui.RadioButton("Multiply Gain", __gainOption == __VED_OPTION_MULTIPLY))
            {
                _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                {
                    _struct.__SetGainOption(__VED_OPTION_MULTIPLY);
                });
            }
            
            __SetGainForce(ImGui.Checkbox("Override sound gain", __gainForce));
            
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
                        __AddSound(_soundName);
                    }
                    else
                    {
                        __DeleteSoundByName(_soundName);
                    }
                }
                
                ++_i;
            }
            
            ImGui.EndCombo();
        }
        
        ImGui.SameLine();
        
        if (ImGui.Button("Clear"))
        {
            var _modal = __VedModalOpen(__VedClassModalClearSounds);
            _modal.__multiselector = _multiselector;
            _modal.__dictionary    = _dictionary;
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
                        __DeleteSoundByIndex(_i);
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