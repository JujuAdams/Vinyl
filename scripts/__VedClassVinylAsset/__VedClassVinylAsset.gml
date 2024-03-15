// Feather disable all

function __VedClassVinylAsset() constructor
{
    __partialPath  = undefined;
    __absolutePath = undefined;
    __name         = undefined;
    
    __modified    = false;
    __gain        = [1, 1];
    __gainOption  = __VED_OPTION_UNSET;
    __pitch       = [1, 1];
    __pitchOption = __VED_OPTION_UNSET;
    
    static __Compile = function(_buffer)
    {
        if (__modified)
        {
            buffer_write(_buffer, buffer_text, "function ");
            buffer_write(_buffer, buffer_text, VED_PREFIX);
            buffer_write(_buffer, buffer_text, __name);
            buffer_write(_buffer, buffer_text, "()\n{\n    return audio_play_sound(");
            buffer_write(_buffer, buffer_text, __name);
            buffer_write(_buffer, buffer_text, ", 1, false, ");
            
            if (__gain[0] == __gain[1])
            {
                buffer_write(_buffer, buffer_text, string(__gain[0]));
            }
            else
            {
                buffer_write(_buffer, buffer_text, " __VinylRandomRange(");
                buffer_write(_buffer, buffer_text, string(__gain[0]));
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, string(__gain[0]));
                buffer_write(_buffer, buffer_text, ")");
            }
            
            buffer_write(_buffer, buffer_text, ", 0, ");
            
            if (__pitch[0] == __pitch[1])
            {
                buffer_write(_buffer, buffer_text, string(__pitch[0]));
            }
            else
            {
                buffer_write(_buffer, buffer_text, " __VinylRandomRange(");
                buffer_write(_buffer, buffer_text, string(__pitch[0]));
                buffer_write(_buffer, buffer_text, ", ");
                buffer_write(_buffer, buffer_text, string(__pitch[0]));
                buffer_write(_buffer, buffer_text, ")");
            }
            
            buffer_write(_buffer, buffer_text, ");\n}\n\n");
        }
        else
        {
            buffer_write(_buffer, buffer_text, "function ");
            buffer_write(_buffer, buffer_text, VED_PREFIX);
            buffer_write(_buffer, buffer_text, __name);
            buffer_write(_buffer, buffer_text, "()\n{\n    return audio_play_sound(");
            buffer_write(_buffer, buffer_text, __name);
            buffer_write(_buffer, buffer_text, ", 1, false);\n}\n\n");
        }
    }
    
    static __SetGain = function(_value)
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
        __pitch = variable_clone(_value);
                    
        //If the two values have inverted then swap 'em over
        if (__pitch[0] > __pitch[1])
        {
            var _temp = __pitch[0];
            __pitch[0] = __pitch[1];
            __pitch[1] = _temp;
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
    
    static __BuildUI = function(_multiselector)
    {
        static _gainOptionArray  = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        static _pitchOptionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        
        ImGui.BeginDisabled(not __modified);
        if (ImGui.BeginTable("Vinyl Properties", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 260))
        {
            //Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Gain");
            
            var _originalOption = __gainOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Gain Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_gainOptionArray))
                {
                    var _optionName = _gainOptionArray[_i];
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
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Gain " + __name, __gain[0], 0, 2);
                    __SetGain([_newValue, _newValue]);
                break;
            
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__gain);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Gain " + __name, _newValue, 0, 2);
                    __SetGain(_newValue);
                break;
            }
            
            //Pitch
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Pitch");
            
            var _originalOption = __pitchOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Pitch Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_pitchOptionArray))
                {
                    var _optionName = _pitchOptionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Pitch Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetPitchOption(_optionName);
                    }
                        
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            switch(__pitchOption)
            {
                case __VED_OPTION_MULTIPLY:
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    var _newValue = ImGui.SliderFloat("##Pitch " + __name, __pitch[0], 0, 2);
                    __SetPitch([_newValue, _newValue]);
                break;
            
                case __VED_OPTION_RANDOMIZE:
                    var _newValue = variable_clone(__pitch);
                    ImGui.SetNextItemWidth(ImGui.GetColumnWidth(2));
                    ImGui.SliderFloat2("##Pitch " + __name, _newValue, 0, 2);
                    __SetPitch(_newValue);
                break;
            }
            
            ImGui.EndTable();
        }
        
        ImGui.EndDisabled();
    }
    
    static __Modify = function()
    {
        __modified = true;
    }
    
    static __Unmodify = function()
    {
        __modified = false;
    }
    
    static __Serialize = function(_array)
    {
        if (__modified)
        {
            array_push(_array, {
                name:        __name,
                gain:        __gain,
                gainOption:  __gainOption,
                pitch:       __pitch,
                pitchOption: __pitchOption,
            });
        }
    }
    
    static __Deserialize = function(_data)
    {
        __modified    = true;
        __name        = _data.name;
        __gain        = _data.gain;
        __gainOption  = _data.gainOption;
        __pitch       = _data.pitch;
        __pitchOption = _data.pitchOption;
    }
}