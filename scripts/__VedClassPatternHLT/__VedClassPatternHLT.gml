// Feather disable all

function __VedClassPatternHLT() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    
    __soundHead   = undefined;
    __soundLoop   = undefined;
    __soundTail   = undefined;
    __gainForce   = false;
    __gain        = 1;
    __gainOption  = __VED_OPTION_UNSET;
    
    static __CompilePlay = function(_buffer)
    {
        buffer_write(_buffer, buffer_text, $"        struct_set_from_hash(_data, {VED_GENERATED_ASSET_PREFIX}{__name}, function(_loop_UNUSED, _gainLocal, _pitchLocal)\n");
        buffer_write(_buffer, buffer_text,  "        {\n");
        buffer_write(_buffer, buffer_text, $"            static _pattern = struct_get_from_hash(__VinylGenPattern(), {VED_GENERATED_ASSET_PREFIX}{__name});\n");
        buffer_write(_buffer, buffer_text,  "            return (new __VinylClassVoiceHLT(_pattern)).__currentVoice;\n");
        buffer_write(_buffer, buffer_text,  "        });\n");
        buffer_write(_buffer, buffer_text,  "\n");
    }
    
    static __CompilePattern = function(_buffer)
    {
        buffer_write(_buffer, buffer_text, $"        struct_set_from_hash(_data, {VED_GENERATED_ASSET_PREFIX}{__name}, new __VinylClassPatternHLT({VED_GENERATED_ASSET_PREFIX}{__name}, {__soundHead}, {__soundLoop}, {__soundTail}, {__gainForce? "true" : "false"}, {__gain}));\n");
    }
    
    static __CompileName = function(_buffer)
    {
        buffer_write(_buffer, buffer_text, $"        _data[$ \"{VED_GENERATED_ASSET_PREFIX}{__name}\"] = {VED_GENERATED_ASSET_PREFIX}{__name};\n");
    }
    
    static __Serialize = function(_array)
    {
        array_push(_array, {
            type:        __VED_PATTERN_TYPE_HEAD_LOOP_TAIL,
            name:        __name,
            soundHead:   __soundHead,
            soundLoop:   __soundLoop,
            soundTail:   __soundTail,
            gainForce:   __gainForce,
            gain:        __gain,
            gainOption:  __gainOption,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name        = _data.name;
        __soundHead   = _data[$ "soundHead" ];
        __soundLoop   = _data[$ "soundLoop" ];
        __soundTail   = _data[$ "soundTail" ];
        __gainForce   = _data[$ "gainForce" ] ?? false;
        __gain        = _data[$ "gain"      ] ?? 1;
        __gainOption  = _data[$ "gainOption"] ?? __VED_OPTION_UNSET;
        
        //2023.8 still has this stupid problem
        if (__soundHead == pointer_null) __soundHead = undefined;
        if (__soundLoop == pointer_null) __soundLoop = undefined;
        if (__soundTail == pointer_null) __soundTail = undefined;
    }
    
    static __BroadcastChange = function()
    {
        __VedNetRPC("VinylCreateHLT", __soundHead, __soundLoop, __soundTail, __gainForce, __gain, VED_GENERATED_ASSET_PREFIX + __name);
    }
    
    static __SetGain = function(_value)
    {
        if (_value != __gain)
        {
            __gain = _value;
            __BroadcastChange();
        }
    }
    
    static __SetGainOption = function(_value)
    {
        if (_value != __gainOption)
        {
            __gainOption = _value;
            __BroadcastChange();
        }
    }
    
    static __SetGainForce = function(_value)
    {
        if (_value != __gainForce)
        {
            __gainForce = _value;
            __BroadcastChange();
        }
    }
    
    static __SetHeadSound = function(_value)
    {
        if (_value != __soundHead)
        {
            __soundHead = _value;
            __BroadcastChange();
        }
    }
    
    static __SetLoopSound = function(_value)
    {
        if (_value != __soundHead)
        {
            __soundLoop = _value;
            __BroadcastChange();
        }
    }
    
    static __SetTailSound = function(_value)
    {
        if (_value != __soundHead)
        {
            __soundTail = _value;
            __BroadcastChange();
        }
    }
    
    static __GetAbbreviation = function()
    {
        return "HLT";
    }
    
    static __BuildUI = function(_multiselector, _dictionary)
    {
        var _soundArray = _system.__project.__libSound.__GetNameArray();
        
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY];
        
        ImGui.Text("Head-Loop-Tail pattern");
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
        
        if (ImGui.BeginTable("Sounds", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 70))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 30);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthStretch, 1);
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
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundHead == _soundName)) __SetHeadSound(_soundName);
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear##Clear Head")) __SetHeadSound(undefined);
            
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
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundLoop == _soundName)) __SetLoopSound(_soundName);
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear##Clear Loop")) __SetLoopSound(undefined);
            
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
                    if (ImGui.Selectable(_soundName + "##Selectable", __soundTail == _soundName)) __SetTailSound(_soundName);
                    ++_i;
                }
            
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            if (ImGui.Button("Clear##Clear Tail")) __SetTailSound(undefined);
            
            ImGui.EndTable();
        }
    }
}