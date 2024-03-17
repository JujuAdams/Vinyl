// Feather disable all

function __VedClassVinylAsset() constructor
{
    __partialPath  = undefined;
    __absolutePath = undefined;
    __name         = undefined;
    
    __loop        = false;
    __gain        = [1, 1];
    __gainOption  = __VED_OPTION_UNSET;
    __pitch       = [1, 1];
    __pitchOption = __VED_OPTION_UNSET;
    
    __tagLoopOption  = __VED_OPTION_SET;
    __tagLoop        = undefined;
    __tagGainOption  = __VED_OPTION_MULTIPLY;
    __tagGain        = [1, 1];
    __tagPitchOption = __VED_OPTION_MULTIPLY;
    __tagPitch       = [1, 1];
    
    static __CompilePlay = function(_buffer)
    {
        if (not __GetModified()) return;
        
        buffer_write(_buffer, buffer_text, "        struct_set_from_hash(_data, int64(");
        buffer_write(_buffer, buffer_text, __name);
        buffer_write(_buffer, buffer_text, "), function(_loop, _gainLocal, _pitchLocal)\n");
        buffer_write(_buffer, buffer_text, "        {\n");
        buffer_write(_buffer, buffer_text, "            var _gainPattern  = ");
        
        if (__gain[0] == __gain[1])
        {
            buffer_write(_buffer, buffer_text, string(__gain[0]));
        }
        else
        {
            buffer_write(_buffer, buffer_text, "*__VinylRandomRange(");
            buffer_write(_buffer, buffer_text, string(__gain[0]));
            buffer_write(_buffer, buffer_text, ", ");
            buffer_write(_buffer, buffer_text, string(__gain[1]));
            buffer_write(_buffer, buffer_text, ")");
        }
        
        buffer_write(_buffer, buffer_text, ";\n");
        buffer_write(_buffer, buffer_text, "            var _pitchPattern = ");
        
        if (__pitch[0] == __pitch[1])
        {
            buffer_write(_buffer, buffer_text, string(__pitch[0]));
        }
        else
        {
            buffer_write(_buffer, buffer_text, "*__VinylRandomRange(");
            buffer_write(_buffer, buffer_text, string(__pitch[0]));
            buffer_write(_buffer, buffer_text, ", ");
            buffer_write(_buffer, buffer_text, string(__pitch[1]));
            buffer_write(_buffer, buffer_text, ")");
        }
        
        buffer_write(_buffer, buffer_text, ";\n");
        buffer_write(_buffer, buffer_text, "            \n");
        buffer_write(_buffer, buffer_text, "            var _voice = audio_play_sound(");
        buffer_write(_buffer, buffer_text, __name);
        buffer_write(_buffer, buffer_text, ", 0, _loop ?? ");
        buffer_write(_buffer, buffer_text, __loop? "true" : "false");
        buffer_write(_buffer, buffer_text, ", _gainLocal*_gainPattern, 0, _pitchLocal*_pitchPattern);\n");
        buffer_write(_buffer, buffer_text, "            \n");
        buffer_write(_buffer, buffer_text, "            if (VINYL_LIVE_EDIT)\n");
        buffer_write(_buffer, buffer_text, "            {\n");
        buffer_write(_buffer, buffer_text, "                __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern).__pattern = ");
        buffer_write(_buffer, buffer_text, __name);
        buffer_write(_buffer, buffer_text, ";\n");
        buffer_write(_buffer, buffer_text, "            }\n");
        buffer_write(_buffer, buffer_text, "            else\n");
        buffer_write(_buffer, buffer_text, "            {\n");
        buffer_write(_buffer, buffer_text, "                __VinylVoiceTrack(_voice, _gainLocal, _pitchLocal, _gainPattern, _pitchPattern);\n");
        buffer_write(_buffer, buffer_text, "            }\n");
        buffer_write(_buffer, buffer_text, "            \n");
        buffer_write(_buffer, buffer_text, "            return _voice;\n");
        buffer_write(_buffer, buffer_text, "        });\n");
        buffer_write(_buffer, buffer_text, "\n");
    }
    
    static __CompilePattern = function(_buffer)
    {
        if (not __GetModified()) return;
        
        buffer_write(_buffer, buffer_text, "        struct_set_from_hash(_data, int64(");
        buffer_write(_buffer, buffer_text, __name);
        buffer_write(_buffer, buffer_text, "), new __VinylClassPatternSound(");
        buffer_write(_buffer, buffer_text, __name);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __loop? "true" : "false");
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __gain[0]);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __gain[1]);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __pitch[0]);
        buffer_write(_buffer, buffer_text, ", ");
        buffer_write(_buffer, buffer_text, __pitch[1]);
        buffer_write(_buffer, buffer_text, "));\n");
        buffer_write(_buffer, buffer_text, "\n");
    }
    
    static __BroadcastChange = function()
    {
        if (__GetModified())
        {
            __VedNetRPC("__VinylOverwritePatternSound", __name, __loop, __gain, __pitch);
        }
        else
        {
            __VedNetRPC("__VinylRemovePatternSound", __name);
        }
    }
    
    static __GetModified = function()
    {
        return ((__loop != false) || (__gainOption != __VED_OPTION_UNSET) || (__pitchOption != __VED_OPTION_UNSET)
             || (__tagLoopOption != __VED_OPTION_SET) || (__tagGainOption != __VED_OPTION_MULTIPLY) || (__tagPitchOption != __VED_OPTION_MULTIPLY))
    }
    
    static __SetLoop = function(_value)
    {
        if (_value != __loop)
        {
            __loop = _value;
            __BroadcastChange();
        }
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
            
            __BroadcastChange();
        }
    }
    
    static __SetGainOption = function(_value)
    {
        __gainOption = _value;
        if (__gainOption == __VED_OPTION_MULTIPLY)
        {
            __SetGain([__gain[0], __gain[0]]);
        }
    }
    
    static __SetPitch = function(_value)
    {
        if (not array_equals(_value, __pitch))
        {
            __pitch = variable_clone(_value);
            
            //If the two values have inverted then swap 'em over
            if (__pitch[0] > __pitch[1])
            {
                var _temp = __pitch[0];
                __pitch[0] = __pitch[1];
                __pitch[1] = _temp;
            }
            
            __BroadcastChange();
        }
    }
    
    static __SetPitchOption = function(_value)
    {
        __pitchOption = _value;
        if (__pitchOption == __VED_OPTION_MULTIPLY)
        {
            __SetPitch([__pitch[0], __pitch[0]]);
        }
    }
    
    static __SetTagLoopOption = function(_value)
    {
        if (__tagLoopOption != _value)
        {
            __tagLoopOption = _value;
            __BroadcastChange();
        }
    }
    
    static __SetTagGainOption = function(_value)
    {
        if (__tagGainOption != _value)
        {
            __tagGainOption = _value;
            __BroadcastChange();
        }
    }
    
    static __SetTagPitchOption = function(_value)
    {
        if (__tagPitchOption != _value)
        {
            __tagPitchOption = _value;
            __BroadcastChange();
        }
    }
    
    static __ResolveProperties = function()
    {
        static _result = {
            __loop:     false,
            __gainMin:  1,
            __gainMax:  1,
            __pitchMin: 1,
            __pitchMax: 1,
        };
        
        _result.__loop = ((__tagLoopOption == __VED_OPTION_SET) && (__tagLoop != undefined))? __tagLoop : __loop;
        
        if (__gainOption == __VED_OPTION_UNSET)
        {
            var _gainMin = 1;
            var _gainMax = 1;
        }
        else
        {
            var _gainMin = __gain[0];
            var _gainMax = __gain[1];
        }
        
        switch(__tagGainOption)
        {
            case __VED_OPTION_MULTIPLY:
                _result.__gainMin = __tagGain[0]*_gainMin;
                _result.__gainMax = __tagGain[1]*_gainMax;
            break;
            
            case __VED_OPTION_SET:
                _result.__gainMin = __tagGain[0];
                _result.__gainMax = __tagGain[1];
            break;
            
            case __VED_OPTION_IGNORE:
                _result.__gainMin = _gainMin;
                _result.__gainMax = _gainMax;
            break;
        }
        
        if (__pitchOption == __VED_OPTION_UNSET)
        {
            var _pitchMin = 1;
            var _pitchMax = 1;
        }
        else
        {
            var _pitchMin = __pitch[0];
            var _pitchMax = __pitch[1];
        }
        
        switch(__tagPitchOption)
        {
            case __VED_OPTION_MULTIPLY:
                _result.__pitchMin = __tagPitch[0]*_pitchMin;
                _result.__pitchMax = __tagPitch[1]*_pitchMax;
            break;
            
            case __VED_OPTION_SET:
                _result.__pitchMin = __tagPitch[0];
                _result.__pitchMax = __tagPitch[1];
            break;
            
            case __VED_OPTION_IGNORE:
                _result.__pitchMin = _pitchMin;
                _result.__pitchMax = _pitchMax;
            break;
        }
        
        return _result;
    }
    
    static __BuildUI = function(_multiselector)
    {
        static _optionArray        = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        static _tagLoopOptionArray = [__VED_OPTION_SET, __VED_OPTION_IGNORE];
        static _tagOptionArray     = [__VED_OPTION_MULTIPLY, __VED_OPTION_SET, __VED_OPTION_IGNORE];
        
        static _funcTextRange = function(_min, _max)
        {
            if (_min == _max)
            {
                ImGui.Text(_min);
            }
            else
            {
                ImGui.Text(string_concat(_min, "   -->   ", _max));
            }
        }
        
        if (ImGui.BeginTable("Final", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 70))
        {
            var _properties = __ResolveProperties();
            
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Final",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableHeadersRow();
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            ImGui.TableSetColumnIndex(1);
            ImGui.Text(_properties.__loop? "Yes" : "No");
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            ImGui.TableSetColumnIndex(1);
            _funcTextRange(_properties.__gainMin, _properties.__gainMax);
            
            //PITCH
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            ImGui.TableSetColumnIndex(1);
            _funcTextRange(_properties.__pitchMin, _properties.__pitchMax);
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Sound", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 110))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Sound",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableHeadersRow();
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            
            ImGui.TableSetColumnIndex(1);
            ImGui.Text(((__tagLoopOption == __VED_OPTION_SET) && (__tagLoop != undefined))? "Overridden" : "Set");
            
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled((__tagLoopOption == __VED_OPTION_SET) && (__tagLoop != undefined));
            __SetLoop(ImGui.Checkbox("##Loop", __loop));
            ImGui.EndDisabled();
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Sound");
            
            var _originalOption = __gainOption;
            ImGui.TableSetColumnIndex(1);
            if (__tagGainOption == __VED_OPTION_SET)
            {
                ImGui.Text("Overridden");
            }
            else
            {
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
            }
            
            ImGui.TableSetColumnIndex(2);
            switch((__tagGainOption == __VED_OPTION_SET)? __VED_OPTION_UNSET : __gainOption)
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
            
            //Pitch
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            
            var _originalOption = __pitchOption;
            ImGui.TableSetColumnIndex(1);
            if (__tagPitchOption == __VED_OPTION_SET)
            {
                ImGui.Text("Overridden");
            }
            else
            {
                ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
                if (ImGui.BeginCombo("##Pitch Option " + __name, _originalOption, ImGuiComboFlags.None))
                {
                    var _i = 0;
                    repeat(array_length(_optionArray))
                    {
                        var _optionName = _optionArray[_i];
                        if (ImGui.Selectable(_optionName + "##Pitch Option " + __name, (_originalOption == _optionName)))
                        {
                            __SetPitchOption(_optionName);
                        }
                        
                        ++_i;
                    }
                    
                    ImGui.EndCombo();
                }
            }
            
            ImGui.TableSetColumnIndex(2);
            switch((__tagPitchOption == __VED_OPTION_SET)? __VED_OPTION_UNSET : __pitchOption)
            {
                case __VED_OPTION_UNSET:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.BeginDisabled(true);
                    var _newValue = ImGui.SliderFloat("##Pitch " + __name, 1, 0.01, 2);
                    ImGui.EndDisabled();
                break;
                
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Pitch " + __name, __pitch[0], 0.01, 2);
                    __SetPitch([_newValue, _newValue]);
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__pitch);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Pitch " + __name, _newValue, 0.01, 2);
                    __SetPitch(_newValue);
                break;
            }
            
            //Reset
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.Button("Reset##Sound"))
            {
                __SetLoop(false);
                __SetGainOption(__VED_OPTION_UNSET);
                __SetPitchOption(__VED_OPTION_UNSET);
            }
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Tags", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 110))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Tags",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableHeadersRow();
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            
            var _originalOption = __tagLoopOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Loop Tag Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_tagLoopOptionArray))
                {
                    var _optionName = _tagLoopOptionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Tag Loop Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetTagLoopOption(_optionName);
                    }
                        
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(__tagLoopOption == __VED_OPTION_IGNORE);
            if (__tagLoop == undefined)
            {
                ImGui.Text("<unset>");
            }
            else
            {
                ImGui.Text(__tagLoop? "Yes" : "No");
            }
            
            ImGui.EndDisabled();
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            
            var _originalOption = __tagGainOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Tag Gain Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_tagOptionArray))
                {
                    var _optionName = _tagOptionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Tag Gain Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetTagGainOption(_optionName);
                    }
                        
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            _funcTextRange(__tagGain[0], __tagGain[1]);
            
            //Pitch
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            
            var _originalOption = __tagPitchOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Tag Pitch Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_tagOptionArray))
                {
                    var _optionName = _tagOptionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Tag Pitch Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetTagPitchOption(_optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            _funcTextRange(__tagPitch[0], __tagPitch[1]);
            
            //Reset
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.Button("Reset##Tag"))
            {
                __SetTagLoopOption(__VED_OPTION_SET);
                __SetTagGainOption(__VED_OPTION_MULTIPLY);
                __SetTagPitchOption(__VED_OPTION_MULTIPLY);
            }
            
            ImGui.EndTable();
        }
    }
    
    static __Serialize = function(_array)
    {
        if (__GetModified())
        {
            array_push(_array, {
                name:           __name,
                loop:           __loop,
                gain:           __gain,
                gainOption:     __gainOption,
                pitch:          __pitch,
                pitchOption:    __pitchOption,
                tagLoopOption:  __tagLoopOption,
                tagGainOption:  __tagGainOption,
                tagPitchOption: __tagPitchOption,
            });
        }
    }
    
    static __Deserialize = function(_data)
    {
        __name           = _data.name;
        __loop           = _data[$ "loop"          ] ?? false;
        __gain           = _data[$ "gain"          ] ?? [1, 1];
        __gainOption     = _data[$ "gainOption"    ] ?? __VED_OPTION_UNSET;
        __pitch          = _data[$ "pitch"         ] ?? [1, 1];
        __pitchOption    = _data[$ "pitchOption"   ] ?? __VED_OPTION_UNSET;
        __tagLoopOption  = _data[$ "tagLoopOption" ] ?? __VED_OPTION_SET;
        __tagGainOption  = _data[$ "tagGainOption" ] ?? __VED_OPTION_MULTIPLY;
        __tagPitchOption = _data[$ "tagPitchOption"] ?? __VED_OPTION_MULTIPLY;
    }
}