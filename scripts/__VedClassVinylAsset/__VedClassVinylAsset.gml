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
    
    __ruleIgnore = false;
    __ruleLoop   = undefined;
    __ruleGain   = [1, 1];
    __rulePitch  = [1, 1];
    
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
            __VedNetRPC("__VinylCreatePatternSound", __name, __loop, __gain, __pitch);
        }
        else
        {
            __VedNetRPC("__VinylRemovePatternSound", __name);
        }
    }
    
    static __GetModified = function()
    {
        return ((__loop != false) || (__gainOption != __VED_OPTION_UNSET) || (__pitchOption != __VED_OPTION_UNSET) || __ruleIgnore)
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
    
    static __SetGainOption = function(_value)
    {
        __gainOption = _value;
        if (__gainOption == __VED_OPTION_MULTIPLY)
        {
            __SetGain([__gain[0], __gain[0]]);
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
    
    static __SetRuleIgnore = function(_value)
    {
        if (__ruleIgnore != _value)
        {
            __ruleIgnore = _value;
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
        
        _result.__loop = ((not __ruleIgnore) && (__ruleLoop != undefined))? __ruleLoop : __loop;
        
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
        
        if (__ruleIgnore)
        {
            _result.__gainMin = __ruleGain[0]*_gainMin;
            _result.__gainMax = __ruleGain[1]*_gainMax;
        }
        else
        {
            _result.__gainMin = _gainMin;
            _result.__gainMax = _gainMax;
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
        
        if (__ruleIgnore)
        {
            _result.__pitchMin = _pitchMin;
            _result.__pitchMax = _pitchMax;
        }
        else
        {
            _result.__pitchMin = __rulePitch[0]*_pitchMin;
            _result.__pitchMax = __rulePitch[1]*_pitchMax;
        }
        
        return _result;
    }
    
    static __BuildUI = function(_multiselector, _dictionary)
    {
        static _optionArray         = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        static _ruleLoopOptionArray = [__VED_OPTION_SET, __VED_OPTION_IGNORE];
        static _ruleOptionArray     = [__VED_OPTION_MULTIPLY, __VED_OPTION_IGNORE];
        
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
        
        if (ImGui.BeginTable("Overview", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 70))
        {
            var _properties = __ResolveProperties();
            
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("From Sound",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("From Rules",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("Final Values",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableHeadersRow();
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            ImGui.TableSetColumnIndex(1);
            ImGui.Text(__loop? "Yes" : "No");
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(__ruleIgnore);
            if (__ruleLoop == undefined)
            {
                ImGui.Text("<unset>");
            }
            else
            {
                ImGui.Text(__ruleLoop? "Yes" : "No");
            }
            ImGui.EndDisabled();
            ImGui.TableSetColumnIndex(3);
            ImGui.Text(_properties.__loop? "Yes" : "No");
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            ImGui.TableSetColumnIndex(1);
            _funcTextRange(__gain[0], __gain[1]);
            ImGui.BeginDisabled(__ruleIgnore);
            ImGui.TableSetColumnIndex(2);
            _funcTextRange(__ruleGain[0], __ruleGain[1]);
            ImGui.EndDisabled();
            ImGui.TableSetColumnIndex(3);
            _funcTextRange(_properties.__gainMin, _properties.__gainMax);
            
            //PITCH
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            ImGui.TableSetColumnIndex(1);
            _funcTextRange(__pitch[0], __pitch[1]);
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(__ruleIgnore);
            _funcTextRange(__rulePitch[0], __rulePitch[1]);
            ImGui.EndDisabled();
            ImGui.TableSetColumnIndex(3);
            _funcTextRange(_properties.__pitchMin, _properties.__pitchMax);
            
            ImGui.EndTable();
        }
        
        ImGui.NewLine();
        
        if (ImGui.BeginTable("Sound", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 180))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Sound",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 27);
            ImGui.TableHeadersRow();
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            
            ImGui.TableSetColumnIndex(1);
            ImGui.BeginDisabled((not __ruleIgnore) && (__ruleLoop != undefined));
            
            var _newValue = ImGui.Checkbox("##Loop", __loop)
            if (__loop != _newValue)
            {
                _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                {
                    _struct.__SetLoop(_metadata);
                },
                _newValue);
            }
            
            ImGui.EndDisabled();
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__loop"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Gain Option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain Option");
            
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
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetGainOption(_metadata);
                        },
                        _optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__gainOption"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
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
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, __gain[0], 0.01, 2);
                    
                    if (_newValue != __gain[0])
                    {
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetGain(_metadata);
                        },
                        [_newValue, _newValue]);
                    }
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__gain);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Gain " + __name, _newValue, 0.01, 2);
                    
                    if (not array_equals(_newValue, __gain))
                    {
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetGain(_metadata);
                        },
                        _newValue);
                    }
                break;
            }
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__gain"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Pitch Option
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch Option");
            
            var _originalOption = __pitchOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Pitch Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_optionArray))
                {
                    var _optionName = _optionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Pitch Option " + __name, (_originalOption == _optionName)))
                    {
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetPitchOption(_metadata);
                        },
                        _optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__pitchOption"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Pitch
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            
            ImGui.TableSetColumnIndex(1);
            switch(__pitchOption)
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
                    
                    if (_newValue != __pitch[0])
                    {
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetPitch(_metadata);
                        },
                        [_newValue, _newValue]);
                    }
                break;
                
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__pitch);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Pitch " + __name, _newValue, 0.01, 2);
                    
                    if (not array_equals(_newValue, __pitch))
                    {
                        _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                        {
                            _struct.__SetPitch(_metadata);
                        },
                        _newValue);
                    }
                break;
            }
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__pitch"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Rule Ignore
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Ignore Rules");
            
            ImGui.TableSetColumnIndex(1);
            var _newValue = ImGui.Checkbox("##Ignore Rules", __ruleIgnore)
            if (__ruleIgnore != _newValue)
            {
                _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                {
                    _struct.__SetRuleIgnore(_metadata);
                },
                _newValue);
            }
            
            if (_multiselector.__GetSelectedCount() > 1)
            {
                ImGui.TableSetColumnIndex(2);
                if (_multiselector.__ValueDifferent(_dictionary, "__ruleIgnore"))
                {
                    ImGui.TextColored("Diff", __VED_COLOUR_RED);
                }
                else
                {
                    ImGui.TextColored("Same", __VED_COLOUR_GREEN);
                }
            }
            
            //Reset
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            if (ImGui.Button("Reset##Sound"))
            {
                _multiselector.__ForEachSelected(_dictionary, function(_name, _struct, _metadata)
                {
                    _struct.__SetLoop(false);
                    _struct.__SetGainOption(__VED_OPTION_UNSET);
                    _struct.__SetPitchOption(__VED_OPTION_UNSET);
                    _struct.__SetRuleIgnore(false);
                });
            }
            
            ImGui.EndTable();
        }
    }
    
    static __Serialize = function(_array)
    {
        if (__GetModified())
        {
            array_push(_array, {
                name:        __name,
                loop:        __loop,
                gain:        __gain,
                gainOption:  __gainOption,
                pitch:       __pitch,
                pitchOption: __pitchOption,
                ruleIgnore:  __ruleIgnore,
            });
        }
    }
    
    static __Deserialize = function(_data)
    {
        __name        = _data.name;
        __loop        = _data[$ "loop"       ] ?? false;
        __gain        = _data[$ "gain"       ] ?? [1, 1];
        __gainOption  = _data[$ "gainOption" ] ?? __VED_OPTION_UNSET;
        __pitch       = _data[$ "pitch"      ] ?? [1, 1];
        __pitchOption = _data[$ "pitchOption"] ?? __VED_OPTION_UNSET;
        __ruleIgnore  = _data[$ "ruleIgnore" ] ?? false;
    }
}