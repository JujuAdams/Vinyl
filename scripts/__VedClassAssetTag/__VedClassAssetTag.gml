// Feather disable all

function __VedClassAssetTag() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    __soundNameArray = [];
    
    __loop        = false;
    __loopOption  = __VED_OPTION_UNSET;
    __gain        = [1, 1];
    __gainOption  = __VED_OPTION_UNSET;
    __pitch       = [1, 1];
    __pitchOption = __VED_OPTION_UNSET;
    
    static __Add = function(_name)
    {
        array_push(__soundNameArray, _name);
    }
    
    static __Remove = function(_name)
    {
        var _index = __VedArrayFindIndex(__soundNameArray, _name);
        if (_index != undefined) array_delete(__soundNameArray, _index, 1);
    }
    
    static __RemoveFromAll = function()
    {
        var _soundDict = _system.__project.__libYYPAsset.__GetDictionary();
        
        var _i = array_length(__soundNameArray)-1;
        repeat(array_length(__soundNameArray))
        {
            _soundDict[$ __soundNameArray[_i]].__SetAssetTag(__name, false);
            --_i;
        }
    }
    
    static __CopyAssetArrayTo = function(_array)
    {
        array_copy(_array, array_length(_array), __soundNameArray, 0, array_length(__soundNameArray));
    }
    
    static __SetLoop = function(_value)
    {
        if (_value != __loop)
        {
            __loop = _value;
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
        }
    }
    
    static __SetLoopOption = function(_value)
    {
        __loopOption = _value;
    }
    
    static __SetGainOption = function(_value)
    {
        __gainOption = _value;
    }
    
    static __SetPitchOption = function(_value)
    {
        __pitchOption = _value;
    }
    
    static __BuildUI = function()
    {
        static _optionArray = [__VED_OPTION_UNSET, __VED_OPTION_MULTIPLY, __VED_OPTION_RANDOMIZE];
        static _loopOptionArray = [__VED_OPTION_UNSET, __VED_OPTION_SET];
        
        if (ImGui.BeginTable("Sound", 3, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 90))
        {
            ////Set up our columns with fixed widths so we get a nice pretty layout
            ImGui.TableSetupColumn("",   ImGuiTableColumnFlags.WidthFixed, 100);
            ImGui.TableSetupColumn("", ImGuiTableColumnFlags.WidthFixed, 125);
            ImGui.TableSetupColumn("",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            //Loop
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Loop");
            
            var _originalOption = __loopOption;
            ImGui.TableSetColumnIndex(1);
            ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
            if (ImGui.BeginCombo("##Loop Option " + __name, _originalOption, ImGuiComboFlags.None))
            {
                var _i = 0;
                repeat(array_length(_loopOptionArray))
                {
                    var _optionName = _loopOptionArray[_i];
                    if (ImGui.Selectable(_optionName + "##Loop Option " + __name, (_originalOption == _optionName)))
                    {
                        __SetLoopOption(_optionName);
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableSetColumnIndex(2);
            ImGui.BeginDisabled(__loopOption == __VED_OPTION_UNSET);
            __SetLoop(ImGui.Checkbox("##Loop", __loop));
            ImGui.EndDisabled();
            
            //Gain
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Sound");
            
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
            
            ImGui.TableSetColumnIndex(2);
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
                __SetLoopOption(__VED_OPTION_UNSET);
                __SetGainOption(__VED_OPTION_UNSET);
                __SetPitchOption(__VED_OPTION_UNSET);
            }
            
            ImGui.EndTable();
        }
        
    }
}